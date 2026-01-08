# utils/ColorUtils.gd
extends Node
class_name ColorUtils

# =====================
# Rarity Colors (Emberbound Palette)
# =====================
static func rarity_color(rarity: String) -> Color:
	match rarity.to_lower():
		"common":     return Color(0.9, 0.9, 0.9)          # Clean white
		"uncommon":   return Color(0.3, 1.0, 0.3)          # Fresh green
		"rare":       return Color(0.3, 0.7, 1.0)          # Cool blue
		"epic":       return Color(0.85, 0.3, 1.0)         # Royal purple
		"legendary":  return Color(1.0, 0.84, 0.0)        # Pure gold
		"mythic":     return Color(1.0, 0.45, 0.15)       # Burning orange
		_:            return Color(0.6, 0.6, 0.6)         # Neutral gray fallback

# Glow variants for particles/shine
static func rarity_glow_color(rarity: String) -> Color:
	return rarity_color(rarity) * Color(1, 1, 1, 0.6)

# Text shadow/outline for readability
static func rarity_outline_color(rarity: String) -> Color:
	return Color(0, 0, 0, 0.8)  # Dark outline works on all

# =====================
# Rarity Ranking
# =====================
static func rarity_rank(rarity: String) -> int:
	match rarity.to_lower():
		"common":     return 1
		"uncommon":   return 2
		"rare":       return 3
		"epic":       return 4
		"legendary":  return 5
		"mythic":     return 6
		_:            return 0

# =====================
# Rarity Checks
# =====================
static func is_rare_or_higher(rarity: String) -> bool:
	return rarity_rank(rarity) >= 3

static func is_epic_or_higher(rarity: String) -> bool:
	return rarity_rank(rarity) >= 4

static func is_legendary_or_higher(rarity: String) -> bool:
	return rarity_rank(rarity) >= 5

static func is_mythic(rarity: String) -> bool:
	return rarity_rank(rarity) == 6

# =====================
# Rarity Stars String
# =====================
static func rarity_stars(rarity: String, filled: String = "★", empty: String = "☆") -> String:
	var rank = rarity_rank(rarity)
	var s = ""
	for i in 6:
		s += filled if i < rank else empty
	return s

# =====================
# Rarity Name (Capitalized)
# =====================
static func rarity_name(rarity: String) -> String:
	match rarity.to_lower():
		"common":     return "Common"
		"uncommon":   return "Uncommon"
		"rare":       return "Rare"
		"epic":       return "Epic"
		"legendary":  return "Legendary"
		"mythic":     return "Mythic"
		_:            return "Unknown"