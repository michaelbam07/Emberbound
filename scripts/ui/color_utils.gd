extends Node
class_name ColorUtils

static func rarity_color(rarity: String) -> Color:
	match rarity.to_lower():
		"common": return Color.WHITE
		"uncommon": return Color.GREEN
		"rare": return Color.BLUE
		"epic": return Color.PURPLE
		"legendary": return Color.GOLD
		"mythic": return Color.ORANGE
		_: return Color.GRAY

static func rarity_rank(rarity: String) -> int:
	match rarity.to_lower():
		"common": return 1
		"uncommon": return 2
		"rare": return 3
		"epic": return 4
		"legendary": return 5
		"mythic": return 6
		_: return 0

static func is_rare(rarity: String) -> bool:
	return rarity_rank(rarity) >= 4
static func is_legendary_or_higher(rarity: String) -> bool:
    return rarity_rank(rarity) >= 5