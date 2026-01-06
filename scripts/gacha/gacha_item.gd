# core/gacha/GachaItem.gd
@tool  # Lets you preview levels/XP in editor!
extends Resource
class_name GachaItem

# =====================
# Signals for UI / Game Feedback
# =====================
signal leveled_up(new_level: int)
signal xp_gained(current_xp: int, needed: int)
signal max_level_reached()
signal merged(duplicate_count: int)  # When dupe is absorbed

# =====================
# Core Properties
# =====================
@export var id: String = "" :
	set(value):
		id = value
		resource_name = name if not name.is_empty() else id

@export var name: String = "New Item"
@export var rarity: String = "common"  # common, uncommon, rare, epic, legendary, mythic

@export var level: int = 1 :
	set(value):
		if value != level:
			level = clampi(value, 1, max_level)
			leveled_up.emit(level)
			if level == max_level:
				max_level_reached.emit()

@export var current_xp: int = 0
@export var max_level: int = 10

# Optional: visual overrides per instance (e.g., skin from event)
@export var custom_icon: Texture2D
@export var custom_name_suffix: String = ""

# =====================
# XP System
# =====================
@export_group("XP Progression")
@export var base_xp_per_level: int = 100
@export var xp_growth_per_level: int = 50   # Linear growth
@export var xp_multiplier_on_dupe: float = 1.5  # Dupes give more XP at higher rarity

# =====================
# Methods
# =====================
func gain_xp(amount: int) -> void:
	if is_max_level():
		return
	
	var effective_amount = amount
	if amount > 0:
		current_xp += effective_amount
		xp_gained.emit(current_xp, get_xp_to_next_level())
	
	while current_xp >= get_xp_to_next_level() and not is_max_level():
		_level_up()

func merge_duplicate(duplicate: GachaItem, dupe_count: int = 1) -> void:
	# Absorb a duplicate: gain XP + dust bonus
	var xp_from_dupe = get_xp_from_duplicate(duplicate.rarity, level) * dupe_count
	gain_xp(xp_from_dupe)
	
	# Extra dust for full merges
	var dust_bonus = get_dust_from_rarity(duplicate.rarity) * dupe_count
	PlayerData.add_dust(dust_bonus)
	
	merged.emit(dupe_count)
	print("%s absorbed %d duplicate(s)! +%d XP, +%d Dust" % [name, dupe_count, xp_from_dupe, dust_bonus])

func _level_up() -> void:
	current_xp -= get_xp_to_next_level()
	level += 1
	leveled_up.emit(level)
	
	if is_max_level():
		max_level_reached.emit()
		print("%s reached MAX LEVEL %d!" % [name, max_level])

# =====================
# XP Calculations
# =====================
func get_xp_to_next_level() -> int:
	if is_max_level():
		return 0
	return base_xp_per_level + (level - 1) * xp_growth_per_level

func get_xp_from_duplicate(rarity: String, current_level: int) -> int:
	var base = get_dust_from_rarity(rarity) * 2  # Rough conversion
	return int(base * (1.0 + (current_level - 1) * 0.1))  # Higher level = more XP

func get_dust_from_rarity(rarity: String) -> int:
	match rarity.to_lower():
		"common": return 5
		"uncommon": return 10
		"rare": return 25
		"epic": return 50
		"legendary": return 100
		"mythic": return 250
		_: return 5

# =====================
# Status Checks
# =====================
func is_max_level() -> bool:
	return level >= max_level

func get_progress_percent() -> float:
	if is_max_level():
		return 1.0
	return float(current_xp) / float(get_xp_to_next_level())

# =====================
# Virtual Hooks (Override in WeaponInstance / CompanionInstance)
# =====================
func apply_level_stats() -> void:
	# Override: apply scaling to damage, health, etc.
	pass

func get_display_name() -> String:
	return name + custom_name_suffix

# =====================
# Editor Validation
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if id.is_empty():
		warnings.append("Item ID is required!")
	if level < 1 or level > max_level:
		warnings.append("Level must be between 1 and max_level")
	return warnings