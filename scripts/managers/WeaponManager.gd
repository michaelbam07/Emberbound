# scripts/managers/WeaponManager.gd
extends Node
class_name WeaponManager

# =====================
# Signals
# =====================
signal weapon_obtained(weapon: WeaponItem, is_new: bool)
signal weapon_leveled_up(weapon: WeaponItem)

# =====================
# Dependencies
# =====================
@export var player_data: PlayerData
@export var weapon_db: WeaponDatabase  # Your singleton with all .tres weapons

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	if not player_data:
		player_data = PlayerData
	if not weapon_db:
		weapon_db = WeaponDB
	
	# Listen to gacha pulls
	GachaManager.pull_completed.connect(_on_pull_completed)

# =====================
# Pull Integration
# =====================
func _on_pull_completed(results: Array[Dictionary]) -> void:
	for res in results:
		if res.item is WeaponItem:
			var is_new = res.is_new
			var weapon: WeaponItem = res.item
			weapon_obtained.emit(weapon, is_new)
			if not is_new:
				weapon_leveled_up.emit(weapon)

# =====================
# Core Access
# =====================
func get_weapon_data(id: String) -> WeaponData:
	return weapon_db.get_weapon(id)

func get_all_weapons() -> Array[WeaponData]:
	return weapon_db.get_all_weapons()

func get_weapons_by_rarity(rarity: String) -> Array[WeaponData]:
	return weapon_db.get_weapons_by_rarity(rarity)

# =====================
# Instance Creation (Used by GachaManager)
# =====================
func create_instance(base_data: WeaponData, level: int = 1) -> WeaponItem:
	if not base_data:
		push_error("Cannot create weapon instance: invalid base data")
		return null
	
	var instance = WeaponItem.new()
	instance.id = base_data.id
	instance.name = base_data.name
	instance.rarity = base_data.rarity
	instance.level = level
	instance.current_xp = 0
	
	# Copy base stats
	instance.base_damage = base_data.base_damage
	instance.damage_scaling_per_level = base_data.scaling.get("damage", 5)
	instance.base_fire_rate = base_data.fire_rate
	instance.fire_rate_scaling = base_data.scaling.get("fire_rate", 0.05)
	instance.base_range = base_data.base_range
	instance.range_scaling = base_data.scaling.get("range", 10)
	
	# Visuals & effects
	instance.icon = base_data.icon
	instance.muzzle_flash = base_data.muzzle_flash
	instance.projectile_scene = base_data.projectile_scene
	instance.fire_sfx = base_data.fire_sfx
	
	# Traits & flavor
	instance.traits = base_data.traits.duplicate()
	instance.flavor_text = base_data.flavor_text
	
	return instance

# =====================
# Utility
# =====================
func has_weapon(id: String) -> bool:
	return player_data.has_weapon(id)

func get_owned_weapon(id: String) -> WeaponItem:
	return player_data.get_weapon(id)