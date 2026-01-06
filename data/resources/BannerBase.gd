# data/resources/BannerBase.gd
@tool  # Edit banners live in the Inspector!
extends Resource
class_name BannerBase

# =====================
# Banner Info
# =====================
@export var id: String = "" :
	set(value):
		id = value
		resource_name = name if not name.is_empty() else id  # Nice display name

@export var name: String = "New Banner"
@export_multiline var description: String = "A mysterious banner from the ashes..."

@export var banner_type: String = "standard"
@export_enum("Standard", "Limited", "Event", "Beginner", "Weapon")
var type_category: String = "Standard"

@export var active: bool = true
@export var start_date: String = ""  # ISO format, e.g., "2026-01-06"
@export var end_date: String = ""    # Empty = permanent

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
# Featured Units (Limited Banners)
# =====================
@export_group("Featured Units")
@export var featured_units: Dictionary = {
	"mythic": [],
	"legendary": [],
	"epic": []
}  # Array[String] of unit IDs

@export var rate_up_multiplier: float = 2.0  # e.g., featured 5★ have 2x rate

# =====================
# Pity System
# =====================
@export_group("Pity System")
@export var hard_pity: Dictionary = {
	"legendary": 50,
	"epic": 10
}  # Pull count → guaranteed

@export var soft_pity_start: Dictionary = {
	"legendary": 40,
	"epic": 7
}

@export var soft_pity_bonus: Dictionary = {
	"legendary": 0.08,  # +8% per pull after soft start
	"epic": 0.15
}

@export var guarantee_4star_every_10: bool = true  # Classic 10-pull guarantee

# =====================
# Visuals
# =====================
@export_group("Visuals")
@export var banner_art: Texture2D
@export var thumbnail: Texture2D
@export var background_color: Color = Color(0.1, 0.1, 0.15)

# =====================
# Virtual Methods (Override in child classes if needed)
# =====================
func get_pool_for_rarity(rarity: String) -> Array[String]:
	# Default: return all units of this rarity (override for special pools)
	return []

func is_featured(unit_id: String, rarity: String) -> bool:
	if featured_units.has(rarity):
		return unit_id in featured_units[rarity]
	return false

# =====================
# Validation
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if id.is_empty():
		warnings.append("Banner ID is required for lookup!")
	
	if name.is_empty() or name == "New Banner":
		warnings.append("Give this banner a cool name!")
	
	# Check rates sum ≈ 1.0
	var total_rate: float = 0.0
	for rate in rarity_rates.values():
		total_rate += rate
	if abs(total_rate - 1.0) > 0.01:
		warnings.append("Rarity rates sum to %.3f (should be ~1.0)" % total_rate)
	
	return warnings