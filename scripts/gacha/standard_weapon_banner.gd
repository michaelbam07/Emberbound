extends BannerBase

func _init():
    id = "std_weapon_001"
    name = "Weapon Summon Banner"
    banner_type = "standard"

    rarity_rates = {"5-star": 0.01, "4-star": 0.05, "3-star": 0.94}

    # Pity rules
    hard_pity = {"5-star": 90, "4-star": 10}
    soft_pity_start = {"5-star": 75, "4-star": 8}
    soft_pity_bonus = {"5-star": 0.02, "4-star": 0.01}

# List all weapons per rarity (IDs or references)
func get_banner_units(rarity: String) -> Array:
    match rarity:
        "5-star":
            return ["wpn_001", "wpn_002"]
        "4-star":
            return ["wpn_003", "wpn_004", "wpn_005"]
        "3-star":
            return ["wpn_006", "wpn_007", "wpn_008", "wpn_009"]
        _:
            return []
