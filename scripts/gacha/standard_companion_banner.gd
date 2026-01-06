extends BannerBase

func _init():
    id = "std_companion_001"
    name = "Companion Summon Banner"
    banner_type = "standard"

    rarity_rates = {"5-star": 0.01, "4-star": 0.05, "3-star": 0.94}

    # Pity rules
    hard_pity = {"5-star": 90, "4-star": 10}
    soft_pity_start = {"5-star": 75, "4-star": 8}
    soft_pity_bonus = {"5-star": 0.02, "4-star": 0.01}

# List all companions per rarity (IDs or references)
func get_banner_units(rarity: String) -> Array:
    match rarity:
        "5-star":
            return ["comp_001", "comp_002"]
        "4-star":
            return ["comp_003", "comp_004", "comp_005"]
        "3-star":
            return ["comp_006", "comp_007", "comp_008", "comp_009"]
        _:
            return []
