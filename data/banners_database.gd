extends Node

# =====================
# Emberbound - Banner Database
# Godot 4.5+ Best Practices: Typed, Enums, Signals, Efficient Lookups
# =====================

# Enums for clarity and safety
enum BannerType { COMPANION, WEAPON, MIXED }

# Pre-build a lookup dictionary for O(1) banner access instead of O(n) loops
@onready var _banner_by_id: Dictionary = _build_banner_lookup()

# =====================
# Banner Data (50 total planned – here’s your clean, validated structure)
# =====================
const BANNERS: Array[Dictionary] = [
	# --- STANDARD BANNERS ---
	{
		"id": "standard_companion",
		"name": "Wanderers of the Ashbelt",
		"type": BannerType.COMPANION,
		"active": true,
		"rarity_rates": {"common": 0.5, "uncommon": 0.3, "rare": 0.13, "epic": 0.055, "legendary": 0.014, "mythic": 0.001},
		"pity": {
			"epic": {"soft_start": 7, "hard": 10, "soft_bonus": 0.15},
			"legendary": {"soft_start": 40, "hard": 50, "soft_bonus": 0.08}
		},
		"pool": ["ash_9", "virex", "solenne", "crow_drift", "dust_hound"],
		"featured": {"mythic": ["solenne"], "legendary": ["virex"]}
	},
	{
		"id": "standard_weapon",
		"name": "Relics of the Dead Rail",
		"type": BannerType.WEAPON,
		"active": true,
		"rarity_rates": {"common": 0.52, "uncommon": 0.28, "rare": 0.13, "epic": 0.05, "legendary": 0.018, "mythic": 0.002},
		"pity": {
			"epic": {"soft_start": 8, "hard": 10, "soft_bonus": 0.12},
			"legendary": {"soft_start": 45, "hard": 60, "soft_bonus": 0.07}
		},
		"pool": ["railspike_mk1", "sunflare_revolver", "void_cleaver", "echo_lance", "ion_totem"],
		"featured": {"legendary": ["sunflare_revolver"]}
	},
	
	# --- LIMITED / EVENT BANNERS (examples) ---
	{
		"id": "inferno_legacy",
		"name": "Inferno Legacy",
		"type": BannerType.WEAPON,
		"active": false,
		"rarity_rates": {"common": 0.45, "uncommon": 0.3, "rare": 0.15, "epic": 0.07, "legendary": 0.02, "mythic": 0.01},
		"pity": {
			"epic": {"soft_start": 5, "hard": 10, "soft_bonus": 0.2},
			"legendary": {"soft_start": 30, "hard": 40, "soft_bonus": 0.1}
		},
		"pool": ["dragon_cannon", "flame_thrower", "fire_cracker", "sunflare_revolver"],
		"featured": {"mythic": ["dragon_cannon"], "legendary": ["sunflare_revolver"]}
	},
	# Add the rest of your 46 banners here following the same pattern!
	
	# Example event banner
	{
		"id": "founders_festival",
		"name": "Founders' Remembrance",
		"type": BannerType.MIXED,
		"active": false,
		"rarity_rates": {"common": 0.3, "uncommon": 0.3, "rare": 0.2, "epic": 0.1, "legendary": 0.07, "mythic": 0.03},
		"pity": {"legendary": {"soft_start": 15, "hard": 25, "soft_bonus": 0.2}},
		"pool": ["god_slayer", "solar_phoenix", "orbital_marker", "vampire_fangs"],
		"featured": {"mythic": ["god_slayer", "solar_phoenix"]}
	}
]

# =====================
# Private: Build fast lookup on ready
# =====================
func _build_banner_lookup() -> Dictionary:
	var lookup: Dictionary = {}
	for banner: Dictionary in BANNERS:
		if banner.has("id"):
			lookup[banner["id"]] = banner
		else:
			push_warning("Banner missing 'id' field: ", banner)
	return lookup


# =====================
# Public API – Clean, Fast, Safe
# =====================

func get_active_banners() -> Array[Dictionary]:
	var active: Array[Dictionary] = []
	for banner: Dictionary in BANNERS:
		if banner.get("active", false):
			active.append(banner)
	return active


func get_banner_by_id(id: String) -> Dictionary:
	return _banner_by_id.get(id, {})


func is_valid_banner_id(id: String) -> bool:
	return _banner_by_id.has(id)


# Improved pull simulation – full rarity rollout with proper cumulative probability
func simulate_rarity_pull(banner_id: String, current_pity: int) -> String:
	var banner: Dictionary = get_banner_by_id(banner_id)
	if banner.is_empty():
		push_error("Invalid banner ID: ", banner_id)
		return "common"
	
	var rates: Dictionary = banner["rarity_rates"].duplicate()
	
	# Apply soft pity (example for legendary – extend to epic/mythic as needed)
	if "legendary" in banner.pity and current_pity >= banner.pity.legendary.soft_start:
		rates.legendary += banner.pity.legendary.soft_bonus
	
	# Safety: normalize if rates somehow exceed 1.0
	var total: float = 0.0
	for rate: float in rates.values():
		total += rate
	if total > 1.0:
		push_warning("Banner rates sum > 1.0 (", total, ") – normalizing")
		for key: String in rates.keys():
			rates[key] /= total
	
	# Roll and check cumulative
	var roll: float = randf()
	var cumulative: float = 0.0
	
	cumulative += rates.get("mythic", 0.0)
	if roll <= cumulative: return "mythic"
	
	cumulative += rates.get("legendary", 0.0)
	if roll <= cumulative: return "legendary"
	
	cumulative += rates.get("epic", 0.0)
	if roll <= cumulative: return "epic"
	
	cumulative += rates.get("rare", 0.0)
	if roll <= cumulative: return "rare"
	
	cumulative += rates.get("uncommon", 0.0)
	if roll <= cumulative: return "uncommon"
	
	# Everything else is common
	return "common"