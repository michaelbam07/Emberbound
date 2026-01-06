# scripts/managers/CompanionManager.gd
extends Node
class_name CompanionManager

# =====================
# Signals — Let the world react
# =====================
signal companion_obtained(companion: CompanionInstance, is_new: bool)
signal companion_leveled_up(companion: CompanionInstance)
signal companion_bond_increased(companion: CompanionInstance)
signal companion_equipped(companion: CompanionInstance)
signal companion_unequipped(companion: CompanionInstance)

# =====================
# Dependencies (Autoloads)
# =====================
@export var player_data: PlayerData
@export var companion_db: CompanionDatabase
@export var gacha_manager: GachaManager

const MAX_EQUIPPED: int = 3

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	if not player_data:
		player_data = PlayerData  # Autoload
	if not companion_db:
		companion_db = CompanionDB
	if not gacha_manager:
		gacha_manager = GachaManager
	
	# Connect to gacha pulls for auto-handling
	gacha_manager.pull_completed.connect(_on_pull_completed)

# =====================
# Pull Integration
# =====================
func _on_pull_completed(results: Array[Dictionary]) -> void:
	for res in results:
		if res.item is CompanionInstance:
			var is_new = res.is_new
			var companion: CompanionInstance = res.item
			companion_obtained.emit(companion, is_new)
			
			if not is_new:
				# Play dupe → bond animation
				companion_bond_increased.emit(companion)

# =====================
# Core Management
# =====================
func get_owned_companions() -> Array[CompanionInstance]:
	return player_data.get_companions()

func get_equipped_companions() -> Array[CompanionInstance]:
	return player_data.get_equipped_companions()

func equip_companion(companion: CompanionInstance) -> bool:
	if get_equipped_companions().size() >= MAX_EQUIPPED:
		return false
	if companion in get_equipped_companions():
		return false
	
	player_data.equip_companion(companion)
	companion_equipped.emit(companion)
	return true

func unequip_companion(companion: CompanionInstance) -> bool:
	if player_data.unequip_companion(companion):
		companion_unequipped.emit(companion)
		return true
	return false

func toggle_equip(companion: CompanionInstance) -> void:
	if companion in get_equipped_companions():
		unequip_companion(companion)
	else:
		equip_companion(companion)

# =====================
# Bond & Progression Helpers
# =====================
func increase_bond(companion: CompanionInstance, amount: int = 20) -> void:
	companion.gain_bond(amount)
	companion_bond_increased.emit(companion)

# Triggered from campfire, battle, etc.
func trigger_campfire_bond() -> void:
	for companion in get_equipped_companions():
		increase_bond(companion, 30 + randi_range(0, 20))

# =====================
# Utility Queries
# =====================
func has_companion(id: String) -> bool:
	return player_data.has_companion(id)

func get_companion_by_id(id: String) -> CompanionInstance:
	return player_data.get_companion(id)

func get_companions_by_rarity(rarity: String) -> Array[CompanionInstance]:
	return get_owned_companions().filter(func(c): return c.rarity == rarity)

func get_favorites() -> Array[CompanionInstance]:
	return get_equipped_companions()  # Or add a favorite flag later