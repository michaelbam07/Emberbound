# scripts/managers/WeaponDatabase.gd
extends Node
class_name WeaponDatabase

@export var weapons: Array[WeaponData] = []

var _by_id: Dictionary = {}

func _ready() -> void:
	_build_lookup()

func _build_lookup() -> void:
	_by_id.clear()
	for weapon in weapons:
		if weapon and not weapon.id.is_empty():
			_by_id[weapon.id] = weapon
		else:
			push_warning("Invalid or missing ID in weapon resource:", weapon)

# =====================
# Public API
# =====================
func get_weapon(id: String) -> WeaponData:
	return _by_id.get(id)

func get_all_by_rarity(rarity: String) -> Array[WeaponData]:
	var result: Array[WeaponData] = []
	for w in weapons:
		if w.rarity == rarity:
			result.append(w)
	return result

func get_random_weapon() -> WeaponData:
	if weapons.is_empty():
		return null
	return weapons[randi() % weapons.size()]

func get_weapons_in_pool(pool_ids: Array[String]) -> Array[WeaponData]:
	var result: Array[WeaponData] = []
	for weapon_id in pool_ids:
		var w = get_weapon(weapon_id)
		if w:
			result.append(w)
	return result