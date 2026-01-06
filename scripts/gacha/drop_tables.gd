# core/gacha/DropTables.gd
extends Node
class_name DropTables

# RNG (seedable for testing)
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()

# =====================
# Main Roll Function (Single Pull)
# =====================
func roll_item(banner: GachaBanner, pity_data: Dictionary) -> Dictionary:
	# pity_data example: {"legendary": 42, "epic": 8, "guaranteed": false}
	var result := {
		"rarity": "",
		"item_id": "",
		"is_featured": false,
		"pity_updated": pity_data.duplicate()
	}
	
	# 1. Apply Soft Pity
	var modified_rates = banner.rarity_rates.duplicate()
	_apply_soft_pity(modified_rates, pity_data, banner)
	
	# 2. Roll Rarity
	result.rarity = _weighted_roll(modified_rates)
	
	# 3. Hard Pity Override
	if _check_hard_pity(pity_data, result.rarity, banner):
		result.rarity = _get_hard_pity_rarity(pity_data, banner)
	
	# 4. Reset pity if high rarity hit
	if result.rarity in ["legendary", "mythic"]:
		result.pity_updated["legendary"] = 0
	if result.rarity in ["epic", "legendary", "mythic"]:
		result.pity_updated["epic"] = 0
	
	# 5. Increment pity counters
	result.pity_updated["legendary"] += 1
	result.pity_updated["epic"] += 1
	
	# 6. Select Item from Pool
	var pool = banner.get_pool()
	var candidates = _get_items_of_rarity(pool, result.rarity)
	if candidates.is_empty():
		push_warning("No items in pool for rarity %s on banner %s" % [result.rarity, banner.id])
		result.item_id = "fallback_common_item"
	else:
		# Apply Featured Rate-Up
		var featured_in_rarity = candidates.filter(func(id): return banner.is_featured(id, result.rarity))
		if not featured_in_rarity.is_empty() and rng.randf() < _get_featured_chance(banner, result.rarity):
			result.item_id = featured_in_rarity[rng.randi() % featured_in_rarity.size()]
			result.is_featured = true
		else:
			result.item_id = candidates[rng.randi() % candidates.size()]
	
	return result

# =====================
# Multi-Pull (10x) with Guarantee
# =====================
func roll_multi_pull(banner: GachaBanner, pity_data: Dictionary) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	var current_pity = pity_data.duplicate()
	var has_epic_plus := false
	
	for i in 10:
		var single = roll_item(banner, current_pity)
		results.append(single)
		current_pity = single.pity_updated
		
		if single.rarity in ["epic", "legendary", "mythic"]:
			has_epic_plus = true
	
	# Multi-pull guarantee: at least 1 epic+
	if banner.multi_pull_guarantee_epic and not has_epic_plus:
		# Replace the worst pull with a guaranteed epic
		var worst_idx = _find_worst_pull_index(results)
		var epic_pool = _get_items_of_rarity(banner.get_pool(), "epic")
		if not epic_pool.is_empty():
			results[worst_idx] = {
				"rarity": "epic",
				"item_id": epic_pool[rng.randi() % epic_pool.size()],
				"is_featured": false,
				"pity_updated": current_pity
			}
	
	# Final pity is from last pull
	results[-1].pity_updated = current_pity
	return results

# =====================
# Pity Logic
# =====================
func _apply_soft_pity(rates: Dictionary, pity: Dictionary, banner: GachaBanner) -> void:
	for rarity in ["legendary", "epic"]:
		var count = pity.get(rarity, 0)
		var start = banner.soft_pity_start.get(rarity, 999)
		if count >= start:
			var bonus = banner.soft_pity_bonus.get(rarity, 0.0)
			rates[rarity] = rates.get(rarity, 0.0) + bonus * (count - start + 1)

func _check_hard_pity(pity: Dictionary, rolled_rarity: String, banner: GachaBanner) -> bool:
	for rarity in ["legendary", "epic"]:
		if pity.get(rarity, 0) >= banner.hard_pity.get(rarity, 999):
			return rolled_rarity != rarity
	return false

func _get_hard_pity_rarity(pity: Dictionary, banner: GachaBanner) -> String:
	if pity.get("legendary", 0) >= banner.hard_pity.get("legendary", 999):
		return "legendary"
	if pity.get("epic", 0) >= banner.hard_pity.get("epic", 999):
		return "epic"
	return "epic"  # fallback

# =====================
# Featured Chance
# =====================
func _get_featured_chance(banner: GachaBanner, rarity: String) -> float:
	if banner.featured_items.is_empty() or rarity == "common":
		return 0.0
	# Example: featured has 50% of the rarity's rate
	return 0.5 * banner.rate_up_multiplier

# =====================
# Helpers
# =====================
func _weighted_roll(rates: Dictionary) -> String:
	var roll = rng.randf()
	var accum: float = 0.0
	for rarity in rates.keys():
		accum += rates[rarity]
		if roll <= accum:
			return rarity
	return "common"  # fallback

func _get_items_of_rarity(pool: Array[String], rarity: String) -> Array[String]:
	# Replace with real lookup when you have CompanionDB / WeaponDB
	# For now: mock based on rarity (replace with actual database call!)
	match rarity:
		"mythic": return ["god_slayer", "solar_phoenix"]
		"legendary": return ["dragon_cannon", "mechanical_mammoth"]
		"epic": return ["shock_gauntlet", "plasma_rifle"]
		"rare": return ["flame_thrower", "repeater_sniper"]
		"uncommon": return ["six_shooter", "hunting_crossbow"]
		_: return ["rusty_revolver", "kitchen_knife"]  # common

func _find_worst_pull_index(results: Array[Dictionary]) -> int:
	var worst_idx = 0
	var worst_rarity = results[0].rarity
	for i in results.size():
		if _rarity_value(results[i].rarity) < _rarity_value(worst_rarity):
			worst_idx = i
			worst_rarity = results[i].rarity
	return worst_idx

func _rarity_value(rarity: String) -> int:
	match rarity:
		"mythic": return 6
		"legendary": return 5
		"epic": return 4
		"rare": return 3
		"uncommon": return 2
		"common": return 1
		_: return 0