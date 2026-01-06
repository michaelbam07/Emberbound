# res://core/gacha/gacha_item.gd
extends Resource
class_name GachaItem

# Shared properties
var id: String
var name: String
var rarity: Dictionary
var level: int = 1
var xp: int = 0
var max_level: int = 10
var passive: Dictionary
var active_ability: Dictionary

# XP system
func gain_xp(amount: int) -> void:
    xp += amount
    while xp >= get_xp_to_next_level():
        level_up()

func level_up() -> void:
    if level < max_level:
        level += 1
        xp -= get_xp_to_next_level()
        print("%s leveled up to %d!" % [name, level])
        # TODO: apply stat scaling if needed

func get_xp_to_next_level() -> int:
    return 100 + (level - 1) * 50 # Example XP curve
# Check if at max level
func is_max_level() -> bool:
    return level >= max_level