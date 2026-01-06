# data/resources/GachaBanner.gd
@tool  # Live editing in Inspector!
extends Resource
class_name GachaBanner

# =====================
# Core Info
# =====================
@export var id: String = "" :
	set(value):
		id = value
		resource_name = name if not name.is_empty() else id

@export var name: String = "New Event Banner"
@export_multiline var description: String = "A limited-time banner with boosted rates!"

@export var banner_type: String = "companion"
@export_enum("Companion", "Weapon", "Mixed")
var type_category: String = "Companion"

# =====================
# Time Window
# =====================
@export_group("Schedule")
@export var start_time: int = 0  # Unix timestamp (use DateTime in editor helper if needed)
@export var end_time: int = 0    # 0 = permanent

func is_active() -> bool:
	if start_time == 0 and end_time == 0:
		return true  # Permanent banner
	var now: int = Time.get_unix_time_from_system()
	return now >= start_time and (end_time == 0 or now <= end_time)

# =====================
# Pull Pool
# =====================
@export_group("Item Pool")
@export var pool_companions: Array[String] = []  # Companion IDs in this banner
@export var pool_weapons: Array[String] = []     # Weapon IDs in this banner

func get_pool() -> Array[String]:
	if banner_type == "companion":
		return pool_companions
	elif banner_type == "weapon":
		return pool_weapons
	else:  # mixed
		return pool_companions + pool_weapons

# =====================
# Rarity Rates (must sum ~1.0)
# =====================
@export_group("Rarity Rates")
@export var rarity_rates: Dictionary = {
	"common": 0.50,
	"uncommon": 0.30,
	"rare": 0.13,
	"epic": 0.055,
	"legendary": 0.014,
	"mythic": 0.001
}

# =====================
# Featured / Rate-Up
# =====================
@export_group("Rate-Up & Featured")
@export var featured_items: Array[String] = []  # IDs that get boosted rates
@export var rate_up_multiplier: float = 2.0     # e.g., featured mythic has 2x chance
@export var featured_is_guaranteed: bool = false  # 50/50 or guaranteed on pity?

# =====================
# Pity System
# =====================
@export_group("Pity System")
@export var hard_pity: Dictionary = {
	"legendary": 50,
	"epic": 10
}

@export var soft_pity_start: Dictionary = {
	"legendary": 40,
	"epic": 7
}

@export var soft_pity_bonus: Dictionary = {
	"legendary": 0.08,
	"epic": 0.15
}

@export var multi_pull_guarantee_epic: bool = true  # 10-pull guarantees at least 1 epic+

# =====================
# Visuals
# =====================
@export_group("Visuals")
@export var banner_art: Texture2D
@export var thumbnail: Texture2D
@export var background_color: Color = Color(0.05, 0.05, 0.15)
@export var glow_color: Color = Color(1, 0.8, 0.4)

# =====================
# Validation Warnings
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if id.is_empty():
		warnings.append("Banner ID is required!")
	
	if name.is_empty() or name == "New Event Banner":
		warnings.append("Give this banner an awesome name!")
	
	# Rate sum check
	var total: float = 0.0
	for rate in rarity_rates.values():
		total += rate
	if abs(total - 1.0) > 0.02:
		warnings.append("Rarity rates sum to %.3f — should be ~1.0" % total)
	
	if is_active() and get_pool().is_empty():
		warnings.append("Active banner has empty item pool!")
	
	return warnings