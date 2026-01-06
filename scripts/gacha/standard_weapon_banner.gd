# banners/StandardWeaponBanner.gd
@tool
extends BannerBase
class_name StandardWeaponBanner

func _init() -> void:
	id = "std_weapon_001"
	name = "Relics of the Dead Rail"
	description = "Standard banner featuring powerful weapons forged from the ashes of the old world."
	banner_type = "weapon"
	active = true
	
	# Rarity Rates (balanced for weapons — slightly higher high-rarity chance)
	rarity_rates = {
		"mythic": 0.002,
		"legendary": 0.018,
		"epic": 0.05,
		"rare": 0.13,
		"uncommon": 0.28,
		"common": 0.52
	}
	
	# Pity System — tuned for weapons (slightly harder than companions)
	hard_pity = {
		"legendary": 60,
		"epic": 10
	}
	soft_pity_start = {
		"legendary": 45,
		"epic": 8
	}
	soft_pity_bonus = {
		"legendary": 0.07,
		"epic": 0.12
	}
	
	multi_pull_guarantee_epic = true
	
	# Visuals — make it feel industrial and dangerous
	banner_art = preload("res://assets/banners/weapon_banner_art.png")
	thumbnail = preload("res://assets/banners/weapon_thumb.png")
	background_color = Color(0.15, 0.05, 0.05)  # Deep crimson
	glow_color = Color(1, 0.3, 0.1)             # Fiery orange

# Override: Full weapon pool per rarity (using your actual weapon IDs!)
func get_pool() -> Array[String]:
	return _get_all_weapon_ids()

func get_banner_units(rarity: String) -> Array[String]:
	match rarity.to_lower():
		"mythic":
			return ["shock_gauntlet", "singularity_launcher", "reaper_of_worlds", "god_slayer"]
		"legendary":
			return ["laser_rifle", "dragon_cannon", "obsidian_blade", "orbital_marker", "vampire_fangs", "chrono_rifle"]
		"epic":
			return ["steam_trap", "void_pistol", "energy_scythe", "storm_caller", "grenade_belt", "plasma_rifle", "titan_hammer", "railgun_lite"]
		"rare":
			return ["dynamite_bundle", "plasma_cutter", "bolter_rifle", "electrified_bat", "repeater_sniper", "acid_mine", "flame_thrower", "heavy_claymore", "poison_dart_gun", "shrapnel_cannon"]
		"uncommon":
			return ["six_shooter", "tomahawk_tom", "hunting_crossbow", "riot_shield", "double_barrel", "serrated_machete", "bear_trap", "carbine_9mm", "fire_cracker", "brass_knuckles"]
		"common":
			return ["rusty_revolver", "kitchen_knife", "wooden_club", "scavenged_pipe", "cracked_pistol", "makeshift_sling", "blunt_hatchet", "training_bow", "iron_spike", "tin_grenade", "militia_rifle", "lead_pellet_gun"]
		_:
			return []

# Helper: All weapons in this banner
func _get_all_weapon_ids() -> Array[String]:
	var all: Array[String] = []
	for r in ["mythic", "legendary", "epic", "rare", "uncommon", "common"]:
		all += get_banner_units(r)
	return all