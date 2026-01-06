extends RefCounted
class_name PlayerStats

# -------------------------------------------------
# Dependencies
# -------------------------------------------------
var player_data: PlayerData

# -------------------------------------------------
# Runtime Tracking
# -------------------------------------------------
var total_pulls: int = 0
var pulls_per_rarity := {}   # e.g., {"5-star": 0, "4-star": 0}

# -------------------------------------------------
# Initialization
# -------------------------------------------------
func _init(_player_data: PlayerData, rarities: Array):
    player_data = _player_data

    # Initialize pulls_per_rarity
    for rarity in rarities:
        pulls_per_rarity[rarity] = 0

# -------------------------------------------------
# Pull / Pity Tracking
# -------------------------------------------------
func record_pull(rarity: String, banner_id: String) -> void:
    # Increment runtime tracking
    total_pulls += 1
    pulls_per_rarity[rarity] += 1

    # Increment saved pity counters
    player_data.increment_pity(banner_id)

func reset_pity(rarity: String, banner_id: String) -> void:
    # Reset saved pity counter for banner
    player_data.reset_pity(banner_id)

# -------------------------------------------------
# Currency Access
# -------------------------------------------------
func add_currency(type: String, amount: int) -> void:
    player_data.add_currency(type, amount)

func spend_currency(type: String, amount: int) -> bool:
    return player_data.spend_currency(type, amount)

func get_currency(type: String) -> int:
    return player_data.get_currency(type)

# -------------------------------------------------
# Inventory Access
# -------------------------------------------------
func add_companion(companion) -> void:
    player_data.add_companion(companion)

func add_weapon(weapon) -> void:
    player_data.add_weapon(weapon)

func get_companions_by_rarity(rarity: String) -> Array:
    return player_data.get_companions_by_rarity(rarity)

func get_weapons_by_type(type: String) -> Array:
    return player_data.get_weapons_by_type(type)

# -------------------------------------------------
# Pity Helpers
# -------------------------------------------------
func get_pity(banner_id: String) -> int:
    return player_data.get_pity(banner_id)
func increment_pity(banner_id: String) -> int:
    return player_data.increment_pity(banner_id)