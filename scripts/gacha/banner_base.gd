extends Resource
class_name BannerBase

# -------------------------------------------------
# Basic Banner Info
# -------------------------------------------------
var id: String = ""
var name: String = ""

# -------------------------------------------------
# Rates per rarity (decimal: 0.01 = 1%)
# -------------------------------------------------
var rarity_rates := {}           # e.g., {"5-star": 0.01, "4-star": 0.05, "3-star": 0.94}

# -------------------------------------------------
# Featured units (for limited banners)
# -------------------------------------------------
var featured_units := {}         # e.g., {"5-star": [], "4-star": []}
var featured_guarantee := {}     # 50/50 flags, e.g., {"5-star": false}

# -------------------------------------------------
# Pity rules
# -------------------------------------------------
var hard_pity := {}              # e.g., {"5-star": 90, "4-star": 10}
var soft_pity_start := {}        # e.g., {"5-star": 75, "4-star": 8}
var soft_pity_bonus := {}        # e.g., {"5-star": 0.02, "4-star": 0.01}

# -------------------------------------------------
# Banner Type
# -------------------------------------------------
var banner_type: String = "standard" # or "limited"

# -------------------------------------------------
# Methods (can be overridden by children)
# -------------------------------------------------
func get_banner_units(rarity: String) -> Array:
    return []  # Override in children for standard/featured units

func is_featured_unit(unit_id: String, rarity: String) -> bool:
    return false  # Only applies to limited banners
