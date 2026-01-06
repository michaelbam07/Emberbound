# res://core/gacha/drop_tables.gd
extends Node
class_name DropTables

# Drop chances for rarities
const RARITY_DROP_TABLE = [
    {"rarity": "common", "chance": 0.50},
    {"rarity": "uncommon", "chance": 0.30},
    {"rarity": "rare", "chance": 0.13},
    {"rarity": "epic", "chance": 0.055},
    {"rarity": "legendary", "chance": 0.014},
    {"rarity": "mythic", "chance": 0.001}
]

# Optional: pity system
var pity_counter: int = 0
var pity_threshold: int = 10 # After 10 pulls without high-rarity, guarantee epic or above

# Pick a rarity based on table and optional pity
func roll_rarity() -> String:
    # If pity counter reached, force high rarity
    if pity_counter >= pity_threshold:
        pity_counter = 0
        return "epic"  # Or "legendary" if you want stricter

    var roll = randf()
    var accum = 0.0
    for entry in RARITY_DROP_TABLE:
        accum += entry.chance
        if roll <= accum:
            if entry.rarity in ["epic", "legendary", "mythic"]:
                pity_counter = 0
            else:
                pity_counter += 1
            return entry.rarity
    # fallback
    return "common"
