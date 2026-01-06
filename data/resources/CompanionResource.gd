# data/resources/CompanionResource.gd
@tool  # Allows editing in the editor even when not running
extends Resource
class_name CompanionResource

# Export everything so it's editable in the Inspector!
@export var id: String = ""
@export var name: String = ""
@export var rarity: String = "common"  # We'll make an enum later
@export var role: String = "brawler"

@export var sprite_key: String = ""

@export_group("Base Stats")
@export var base_health: int = 50
@export var base_damage: int = 10
@export var base_attack_speed: float = 1.0
@export var base_move_speed: int = 150

@export_group("Abilities")
@export var passive_name: String = ""
@export var passive_description: String = ""

@export var active_ability_name: String = ""
@export var active_ability_description: String = ""
@export var active_cooldown: float = 0.0
@export var active_duration: float = 0.0

@export_group("Flavor & Lore")
@export var personality: String = ""
@export var flavor_text: String = ""
@export_multiline var lore: String = ""

@export var relationships: Array[String] = []  # Array of companion IDs

# Optional: preview in editor
func _get_configuration_warning() -> String:
	if id.is_empty():
		return "Companion ID is required!"
	return ""