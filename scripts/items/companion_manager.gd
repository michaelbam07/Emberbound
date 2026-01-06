# res://core/companions/companion_manager.gd
extends Node

class_name CompanionManager

signal companion_obtained(new_companion: Companion)

# ===================
# Properties
# ===================
var all_companions: Dictionary = {}    # All companions loaded from companion_data.gd
var owned_companions: Dictionary = {}  # Companion ID -> Companion instance
var equipped_companions: Array = []    # Currently equipped companions (max 3 for example)

# Pity system counters
var pity_counter: Dictionary = {
	"rare": 0,
	"epic": 0,
	"legendary": 0,
	"mythic": 0
}

# Pity thresholds (guarantee after X pulls)
const PITY_THRESHOLD = {
	"rare": 10,
	"epic": 25,
	"legendary": 50,
	"mythic": 100
}

# ===================
# Initialization
# ===================
func _init(companion_data: Dictionary) -> void:
	all_companions = companion_data
	owned_companions.clear()
	equipped_companions.clear()
	reset_pity()

func reset_pity() -> void:
	for key in pity_counter.keys():
		pity_counter[key] = 0

# ===================
# Companion Management
# ===================
func add_companion(companion_id: String) -> Companion:
	if not all_companions.has(companion_id):
		print("Companion not found: %s" % companion_id)
		return null

	if owned_companions.has(companion_id):
		# Already owned: maybe convert to shards/dust
		print("Already owned %s. Granting shards instead." % companion_id)
		return owned_companions[companion_id]

	var new_companion = Companion.new(all_companions[companion_id])
	owned_companions[companion_id] = new_companion
	emit_signal("companion_obtained", new_companion)
	return new_companion

func equip_companion(companion_id: String) -> bool:
	if not owned_companions.has(companion_id):
		print("Cannot equip unowned companion: %s" % companion_id)
		return false
	if companion_id in equipped_companions:
		print("Companion already equipped: %s" % companion_id)
		return false
	if equipped_companions.size() >= 3:
		print("Max equipped companions reached")
		return false
	equipped_companions.append(companion_id)
	print("Equipped %s" % companion_id)
	return true

func unequip_companion(companion_id: String) -> bool:
	if companion_id in equipped_companions:
		equipped_companions.erase(companion_id)
		print("Unequipped %s" % companion_id)
		return true
	return false

# ===================
# Gacha / Random Pull with Pity
# ===================
func pull_random_companion() -> Companion:
	# 1️⃣ Check for guaranteed pity
	for rarity_key in ["mythic", "legendary", "epic", "rare"]:
		if pity_counter[rarity_key] >= PITY_THRESHOLD[rarity_key]:
			print("Pity triggered for %s!" % rarity_key)
			pity_counter[rarity_key] = 0
			var rarity = get_rarity_by_name(rarity_key)
			return add_companion(get_random_companion_by_rarity(rarity).id)

	# 2️⃣ Normal weighted roll
	var total_weight := 0.0
	var weighted_companions := []

	for companion in all_companions.values():
		var weight = companion.rarity.dropRate
		total_weight += weight
		weighted_companions.append({"companion": companion, "weight": weight})

	var roll = randf() * total_weight
	var cumulative = 0.0
	for entry in weighted_companions:
		cumulative += entry.weight
		if roll <= cumulative:
			var pulled = add_companion(entry.companion.id)
			update_pity(entry.companion.rarity.id)
			return pulled

	# Fallback
	var fallback = weighted_companions[0].companion
	return add_companion(fallback.id)

# ===================
# Pity Updates
# ===================
func update_pity(rarity_id: String) -> void:
	# Reset higher rarity pity if pulled
	match rarity_id:
		"mythic":
			pity_counter["mythic"] = 0
			pity_counter["legendary"] += 1
			pity_counter["epic"] += 1
			pity_counter["rare"] += 1
		"legendary":
			pity_counter["legendary"] = 0
			pity_counter["epic"] += 1
			pity_counter["rare"] += 1
			pity_counter["mythic"] += 1
		"epic":
			pity_counter["epic"] = 0
			pity_counter["rare"] += 1
			pity_counter["legendary"] += 1
			pity_counter["mythic"] += 1
		"rare":
			pity_counter["rare"] = 0
			pity_counter["epic"] += 1
			pity_counter["legendary"] += 1
			pity_counter["mythic"] += 1
		_:
			# Common or undefined
			pity_counter["rare"] += 1
			pity_counter["epic"] += 1
			pity_counter["legendary"] += 1
			pity_counter["mythic"] += 1

# ===================
# Utility
# ===================
func get_owned_companions() -> Array:
	return owned_companions.values()

func get_equipped_companions() -> Array:
	var equipped_list = []
	for id in equipped_companions:
		if owned_companions.has(id):
			equipped_list.append(owned_companions[id])
	return equipped_list

# Helper to fetch rarity dictionary by name
func get_rarity_by_name(name: String) -> Dictionary:
	for companion in all_companions.values():
		if companion.rarity.id == name:
			return companion.rarity
	return {}
