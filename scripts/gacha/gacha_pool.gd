# core/gacha/GachaPool.gd
extends RefCounted
class_name GachaPool

# =====================
# Databases (Autoloads or injected)
# =====================
@export var companion_db: CompanionDatabase  # Your CompanionDB singleton
@export var weapon_db: WeaponDatabase        # Your WeaponDB singleton

# Optional cache if loading from dicts (legacy support)
var companion_pool: Dictionary = {}  # rarity → Array[Resource]
var weapon_pool: Dictionary = {}     # rarity → Array[Resource]

# =====================
# Initialization
# =====================
func _init() -> void:
	# Auto-grab databases if Autoloaded
	if not companion_db and Engine.has_singleton("CompanionDB"):
		companion_db = Engine.get_singleton("CompanionDB")
	if not weapon_db and Engine.has_singleton("WeaponDB"):
		weapon_db = Engine.get_singleton("WeaponDB")

# =====================
# Legacy Loaders (Keep for old data)
# =====================
func load_companions_legacy(data: Array[Dictionary]) -> void:
	companion_pool = _group_by_rarity(data)

func load_weapons_legacy(data: Array[Dictionary]) -> void:
	weapon_pool = _group_by_rarity(data)

# =====================
# Modern Roll (Banner-Driven)
# =====================
func roll_from_banner(banner: GachaBanner, pity_result: Dictionary) -> Resource:
	var rarity: String = pity_result.rarity
	var is_featured: bool = pity_result.is_featured
	var item_id: String = pity_result.item_id
	
	var db = companion_db if banner.banner_type == "companion" else weapon_db
	if not db:
		push_error("GachaPool: Missing database for type %s" % banner.banner_type)
		return null
	
	var item = db.get_item(item_id)
	if not item:
		push_warning("GachaPool: Item ID '%s' not found in %s database" % [item_id, banner.banner_type])
		return null
	
	return item

# =====================
# Legacy Rolls (For old flow)
# =====================
func roll_companion_legacy(rarity_table: Dictionary) -> Dictionary:
	var rarity = _roll_rarity(rarity_table)
	return _roll_from_pool_legacy(companion_pool, rarity)

func roll_weapon_legacy(rarity_table: Dictionary) -> Dictionary:
	var rarity = _roll_rarity(rarity_table)
	return _roll_from_pool_legacy(weapon_pool, rarity)

# =====================
# Core Logic (Reused)
# =====================
func _group_by_rarity(data: Array[Dictionary]) -> Dictionary:
	var grouped: Dictionary = {}
	for item in data:
		var rarity_str: String = "common"
		var rarity_val = item.get("rarity", "common")
		if rarity_val is Dictionary:
			rarity_str = rarity_val.get("id", "common").to_lower()
		else:
			rarity_str = str(rarity_val).to_lower()
		
		if not grouped.has(rarity_str):
			grouped[rarity_str] = []
		grouped[rarity_str].append(item)
	return grouped

func _roll_rarity(rarity_table: Dictionary) -> String:
	var roll = randf()
	var accum: float = 0.0
	for rarity in rarity_table.keys():
		accum += rarity_table[rarity]
		if roll <= accum:
			return rarity.to_lower()
	return rarity_table.keys().back()  # fallback

func _roll_from_pool_legacy(pool: Dictionary, rarity: String) -> Dictionary:
	var items: Array = pool.get(rarity, [])
	if items.is_empty():
		push_warning("GachaPool: Empty pool for rarity '%s'" % rarity)
		return {}
	return items[randi() % items.size()]