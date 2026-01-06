# banners/StandardCompanionBanner.gd
@tool  # Edit in Inspector if attached to a node
extends BannerBase
class_name StandardCompanionBanner

func _init() -> void:
	id = "std_companion_001"
	name = "Wanderers of the Ashbelt"
	description = "Standard banner with increased rates for core companions."
	banner_type = "companion"
	active = true
	
	# Rarity Rates (must sum ~1.0)
	rarity_rates = {
		"mythic": 0.001,
		"legendary": 0.014,
		"epic": 0.055,
		"rare": 0.13,
		"uncommon": 0.30,
		"common": 0.50
	}
	
	# Pity System
	hard_pity = {
		"legendary": 50,
		"epic": 10
	}
	soft_pity_start = {
		"legendary": 40,
		"epic": 7
	}
	soft_pity_bonus = {
		"legendary": 0.08,
		"epic": 0.15
	}
	
	multi_pull_guarantee_epic = true
	
	# Visuals (optional but juicy)
	banner_art = preload("res://assets/banners/standard_companion_art.png")
	thumbnail = preload("res://assets/banners/standard_thumb.png")
	background_color = Color(0.1, 0.15, 0.2)
	glow_color = Color(0.8, 0.7, 0.4)

# Override to define the actual pool
func get_pool() -> Array[String]:
	return _get_all_companion_ids()

func get_banner_units(rarity: String) -> Array[String]:
	match rarity.to_lower():
		"mythic":
			return ["lady_lumina", "ember_ignis"]
		"legendary":
			return ["ghost_rider_rex", "the_undertaker", "spirit_stallion", "jade_dragon"]
		"epic":
			return ["phantom_coyote", "scorpion_sally", "clockwork_deputy", "medicine_mare", "dynamite_dave"]
		"rare":
			return ["silver_fox", "iron_hawk", "prospector_pete", "rattlesnake_rita"]
		"uncommon":
			return ["cactus_carl", "copper_crow", "whiskey_weasel", "tumble_tom"]
		"common":
			return ["rustys_rat", "billy_the_beetle", "dust_bunny", "sand_lizard", "pebble_pup"]
		_:
			return []

# Helper: All companions in this banner
func _get_all_companion_ids() -> Array[String]:
	var all: Array[String] = []
	for rarity in ["mythic", "legendary", "epic", "rare", "uncommon", "common"]:
		all += get_banner_units(rarity)
	return all

# Optional: Featured (for future rate-up)
# featured_items = ["lady_lumina", "ghost_rider_rex"]
# rate_up_multiplier = 2.0