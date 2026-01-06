extends Node
class_name WeaponManager

var weapons: Dictionary = {} # id -> WeaponData

func register_weapon(data: WeaponData) -> void:
	weapons[data.id] = data

func get_weapon(id: String) -> WeaponData:
	return weapons.get(id)

func create_instance(id: String, level: int = 1) -> Dictionary:
	var data := get_weapon(id)
	if data == null:
		push_error("Weapon not found: %s" % id)
		return {}

	var dmg := data.base_damage
	if data.scaling.has("damage"):
		dmg += data.scaling["damage"] * (level - 1)

	return {
		"id": data.id,
		"name": data.name,
		"rarity": data.rarity,
		"type": data.weapon_type,
		"level": level,
		"damage": dmg,
		"fire_rate": data.fire_rate,
		"range": data.range,
		"traits": data.traits
	}
