extends RefCounted
class_name GachaPool

# -------------------------------------------------
# Internal pools
# rarity -> Array[Dictionary]
# -------------------------------------------------
var companion_pool: Dictionary = {}
var weapon_pool: Dictionary = {}

# -------------------------------------------------
# Loaders
# -------------------------------------------------
func load_companions(data: Array) -> void:
	companion_pool = _group_by_rarity(data)

func load_weapons(data: Array) -> void:
	weapon_pool = _group_by_rarity(data)

# -------------------------------------------------
# Public Rolls
# -------------------------------------------------

# rarity_table example:
# { "common": 0.5, "rare": 0.13, "epic": 0.05 }
func roll_companion(rarity_table: Dictionary) -> Dictionary:
	var rarity = _roll_rarity(rarity_table)
	return _roll_from_pool(companion_pool, rarity)

func roll_weapon(rarity_table: Dictionary) -> Dictionary:
	var rarity = _roll_rarity(rarity_table)
	return _roll_from_pool(weapon_pool, rarity)

# -------------------------------------------------
# Core Logic
# -------------------------------------------------

func _group_by_rarity(data: Array) -> Dictionary:
	var grouped := {}
	for item in data:
		var rarity_val = item.get("rarity", "common")
		var rarity: String
		if rarity_val is Dictionary:
			rarity = rarity_val.get("id", "common")
		else:
			rarity = str(rarity_val).to_lower()
		if not grouped.has(rarity):
			grouped[rarity] = []
		grouped[rarity].append(item)
	return grouped

func _roll_rarity(rarity_table: Dictionary) -> String:
	var total := 0.0
	for weight in rarity_table.values():
		total += weight

	var roll := randf() * total
	var accum := 0.0

	for rarity in rarity_table.keys():
		accum += rarity_table[rarity]
		if roll <= accum:
			return rarity

	# fallback (should never hit)
	return rarity_table.keys()[0]

func _roll_from_pool(pool: Dictionary, rarity: String) -> Dictionary:
	if not pool.has(rarity) or pool[rarity].is_empty():
		push_warning("No items for rarity: %s" % rarity)
		return {}

	var items: Array = pool[rarity]
	return items[randi() % items.size()]
