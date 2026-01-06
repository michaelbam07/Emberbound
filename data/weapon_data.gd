# data/resources/WeaponData.gd
@tool
extends Resource
class_name WeaponData

@export var id: String = ""
@export var name: String = "Unnamed Weapon"
@export var rarity: String = "common"  # "common", "uncommon", etc.
@export var type: String = "gun"       # "gun", "melee", "explosive", "trap", "sniper"

@export_group("Stats")
@export var damage: int = 10
@export var fire_rate: float = 1.0
@export var range: float = 300.0

@export_group("Abilities")
@export var passive: Dictionary = {}   # {name: "", description: ""}
@export var active_ability: Dictionary = {}  # {name: "", description: "", cooldown: 0, duration: 0}

@export_group("Flavor")
@export_multiline var flavor_text: String = ""

@export_group("Visuals")
@export var icon: Texture2D
@export var projectile_scene: PackedScene
@export var muzzle_flash: PackedScene
@export var fire_sfx: AudioStream

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if id.is_empty():
		warnings.append("Weapon ID is required!")
	if name == "Unnamed Weapon":
		warnings.append("Give this beauty a real name!")
	return warnings