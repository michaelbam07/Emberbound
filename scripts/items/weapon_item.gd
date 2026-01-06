# core/gacha/weapon_item.gd
@tool
extends GachaItem
class_name WeaponItem

# =====================
# Core Weapon Stats
# =====================
@export var base_damage: int = 20
@export var damage_scaling_per_level: int = 5

@export var base_fire_rate: float = 1.0  # Shots per second
@export var fire_rate_scaling: float = 0.05  # +5% per level

@export var base_range: int = 300
@export var range_scaling: int = 10

# Optional advanced stats
@export var crit_chance: float = 0.05
@export var crit_multiplier: float = 2.0
@export var magazine_size: int = 10
@export var reload_time: float = 2.0

# =====================
# Visuals & Effects
# =====================
@export var icon: Texture2D
@export var muzzle_flash: PackedScene
@export var projectile_scene: PackedScene
@export var fire_sfx: AudioStream
@export var reload_sfx: AudioStream

# =====================
# Traits & Flavor
# =====================
@export var traits: Array[String] = []  # "explosive", "piercing", "burning", "void"
@export_multiline var flavor_text: String = ""

# =====================
# Runtime Calculated Stats
# =====================
var current_damage: int : get = get_current_damage
var current_fire_rate: float : get = get_current_fire_rate
var current_range: int : get = get_current_range

func get_current_damage() -> int:
	return base_damage + (level - 1) * damage_scaling_per_level

func get_current_fire_rate() -> float:
	return base_fire_rate * (1.0 + (level - 1) * fire_rate_scaling)

func get_current_range() -> int:
	return base_range + (level - 1) * range_scaling

# =====================
# Progression Overrides
# =====================
func apply_level_stats() -> void:
	# Called on level up — can trigger UI updates or combat recalc
	print("%s upgraded! Damage: %d → %d | Fire Rate: %.2f" % [name, base_damage + (level - 2) * damage_scaling_per_level, current_damage, current_fire_rate])

# =====================
# Display
# =====================
func get_display_name() -> String:
	var suffix = " (Lv.%d)" % level
	if level == max_level:
		suffix += " [MAX]"
	return name + suffix

# =====================
# Editor Validation
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if base_damage <= 0:
		warnings.append("Base damage should be > 0")
	if icon == null:
		warnings.append("Add an icon — weapons deserve to look deadly!")
	return warnings