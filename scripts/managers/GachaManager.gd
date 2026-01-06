# scripts/managers/GachaManager.gd
extends Node
class_name GachaManager

# =====================
# Signals for UI / Animation Hooks
# =====================
signal pull_started(is_multi: bool)
signal pull_completed(results: Array[Dictionary])  # Each: {item: GachaItem, rarity: String, is_new: bool, is_featured: bool}
signal insufficient_currency(currency: String, needed: int, current: int)

# =====================
# Dependencies (Autoloads or injected)
# =====================
@export var player_data: PlayerData
@export var banner_manager: BannerManager
@export var drop_tables: DropTables

# =====================
# Costs
# =====================
const SINGLE_PULL_COST := 100   # Dust, gems, whatever
const MULTI_PULL_COST := 900    # Discounted 10x

# =====================
# Godot Lifecycle
# =====================
func _ready() -> void:
	if not player_data:
		player_data = PlayerData  # Assuming Autoload
	if not banner_manager:
		banner_manager = BannerManager
	if not drop_tables:
		drop_tables = DropTables.new()

# =====================
# Public Pull API
# =====================
func perform_single_pull() -> void:
	if not _can_afford(SINGLE_PULL_COST):
		insufficient_currency.emit("Dust", SINGLE_PULL_COST, player_data.dust)
		return
	
	player_data.spend_dust(SINGLE_PULL_COST)
	pull_started.emit(false)
	
	var banner = banner_manager.get_active_banner()
	if not banner:
		push_error("GachaManager: No active banner!")
		return
	
	var pity = player_data.get_pity_for_banner(banner.id)
	var result = drop_tables.roll_item(banner, pity)
	
	player_data.update_pity_for_banner(banner.id, result.pity_updated)
	var item = _create_or_merge_item(result.item_id, result.rarity, banner.banner_type)
	
	var pull_result = {
		"item": item,
		"rarity": result.rarity,
		"is_new": not result.get("was_duplicate", false),
		"is_featured": result.is_featured
	}
	
	pull_completed.emit([pull_result])

func perform_multi_pull() -> void:
	if not _can_afford(MULTI_PULL_COST):
		insufficient_currency.emit("Dust", MULTI_PULL_COST, player_data.dust)
		return
	
	player_data.spend_dust(MULTI_PULL_COST)
	pull_started.emit(true)
	
	var banner = banner_manager.get_active_banner()
	if not banner:
		push_error("GachaManager: No active banner!")
		return
	
	var pity = player_data.get_pity_for_banner(banner.id)
	var results = drop_tables.roll_multi_pull(banner, pity)
	
	var pull_results: Array[Dictionary] = []
	for res in results:
		var item = _create_or_merge_item(res.item_id, res.rarity, banner.banner_type)
		pull_results.append({
			"item": item,
			"rarity": res.rarity,
			"is_new": not res.get("was_duplicate", false),
			"is_featured": res.is_featured
		})
	
	# Final pity update from last roll
	player_data.update_pity_for_banner(banner.id, results[-1].pity_updated)
	
	pull_completed.emit(pull_results)

# =====================
# Item Creation / Dupe Merging
# =====================
func _create_or_merge_item(item_id: String, rarity: String, banner_type: String) -> GachaItem:
	var db = CompanionDB if banner_type == "companion" else WeaponDB
	var base_data = db.get_item(item_id)
	if not base_data:
		push_error("Unknown item ID: %s" % item_id)
		return null
	
	# Check for existing owned copy
	var existing = player_data.find_owned_item(item_id)
	if existing:
		# DUPE → Merge into progression
		var dupe_instance = GachaItem.new()
		dupe_instance.id = item_id
		dupe_instance.rarity = rarity
		existing.merge_duplicate(dupe_instance)
		return existing  # Return the upgraded original
	
	# NEW ITEM
	var new_item = GachaItem.new()
	new_item.id = base_data.id
	new_item.name = base_data.name
	new_item.rarity = rarity
	new_item.level = 1
	new_item.current_xp = 0
	# Copy other base data (icon, passive, etc.)
	if "icon" in base_data:
		new_item.custom_icon = base_data.icon
	
	player_data.add_item(new_item)
	return new_item

# =====================
# Currency & Safety
# =====================
func _can_afford(cost: int) -> bool:
	return player_data.dust >= cost

# =====================
# Optional: Free Pulls / Bonuses
# =====================
func perform_free_pull(banner_override: BannerBase = null) -> void:
	var banner = banner_override if banner_override else banner_manager.get_active_banner()
	if not banner:
		return
	
	var pity = player_data.get_pity_for_banner(banner.id)
	var result = drop_tables.roll_item(banner, pity)
	player_data.update_pity_for_banner(banner.id, result.pity_updated)
	var item = _create_or_merge_item(result.item_id, result.rarity, banner.banner_type)
	
	pull_completed.emit([{
		"item": item,
		"rarity": result.rarity,
		"is_new": not result.get("was_duplicate", false),
		"is_featured": result.is_featured,
		"is_free": true
	}])