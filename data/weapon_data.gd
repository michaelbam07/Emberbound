extends Resource
class_name WeaponData

@export var id: String
@export var name: String
@export var rarity: String
@export var weapon_type: String # gun, blade, launcher, relic, etc

@export var base_damage: int
@export var fire_rate: float
@export var range: int

@export var scaling: Dictionary = {} # per-level scaling
@export var traits: Array[String] = []
@export var lore: String = ""
