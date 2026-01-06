extends RefCounted
class_name CompanionInstance

var id: String
var name: String
var rarity: String
var role: String

var level: int = 1
var bond: int = 0

var passive: Dictionary
var active_ability: Dictionary
var personality: String

var equipped_weapon: Dictionary = {}

func equip_weapon(weapon_instance: Dictionary) -> void:
	equipped_weapon = weapon_instance

func gain_bond(amount: int) -> void:
	bond += amount
    if bond > level * 100:
        bond = 0
        level += 1