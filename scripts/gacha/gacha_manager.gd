extends Node
class_name GachaManager

const CompanionsData = preload("res://data/companions.gd")
const WeaponsData = preload("res://data/weapons.gd")

# Core systems
var gacha_pool: GachaPool
var pity_system: PitySystem
var player_data: PlayerData

# Active banner
var current_banner: BannerBase

# -------------------------------------------------
# Godot lifecycle
# -------------------------------------------------
func _ready() -> void:
	player_data = PlayerData.get_instance()
	pity_system = PitySystem.new()
	gacha_pool = GachaPool.new()

	_load_data()

# -------------------------------------------------
# Data loading
# -------------------------------------------------
func _load_data() -> void:
	gacha_pool.load_companions(CompanionsData.COMPANIONS.values())
	gacha_pool.load_weapons(WeaponsData.WEAPONS.values())

# -------------------------------------------------
# Set the active banner
# -------------------------------------------------
func set_banner(banner: BannerBase) -> void:
	current_banner = banner

# -------------------------------------------------
# PUBLIC API — Gacha Pulls
# -------------------------------------------------
func pull_companion() -> CompanionItem:
	if current_banner == null:
		push_error("No active banner set")
		return null

	var rarity := _determine_rarity("companion")
	var unit_id := _select_unit("companion", rarity)
	var data: Dictionary = gacha_pool.get_companion_data(unit_id)
	var item := _build_companion(data)

	player_data.add_companion(item)
	_update_pity(rarity)
	player_data.save()

	# UI updates
	var color = _get_rarity_color(item.rarity)
	UIManager.get_instance().show_popup("⭐ " + item.name + " acquired! ⭐", color)
	UIManager.get_instance().update_currency("gems", player_data.get_currency("gems"))
	UIManager.get_instance().update_level(player_data.player_level)

	return item

func pull_weapon() -> WeaponItem:
	if current_banner == null:
		push_error("No active banner set")
		return null

	var rarity := _determine_rarity("weapon")
	var unit_id := _select_unit("weapon", rarity)
	var data: Dictionary = gacha_pool.get_weapon_data(unit_id)
	var item := _build_weapon(data)

	player_data.add_weapon(item)
	_update_pity(rarity)
	player_data.save()

	# UI updates
	var color = _get_rarity_color(item.rarity)
	UIManager.get_instance().show_popup("🔹 " + item.name + " acquired!", color)
	UIManager.get_instance().update_currency("gems", player_data.get_currency("gems"))
	UIManager.get_instance().update_level(player_data.player_level)

	return item

# -------------------------------------------------
# Pull Helpers
# -------------------------------------------------
func _determine_rarity(_type: String) -> String:
	var base_rate := current_banner.rarity_rates
	var _pity_count: int = player_data.get_pity(current_banner.id)
	var rarity := pity_system.get_rarity_with_pity(base_rate, player_data.pity_counters, current_banner.id)
	return rarity

func _select_unit(_type: String, rarity: String) -> String:
	var units := current_banner.get_banner_units(rarity)

	# Limited banner 50/50 logic
	if current_banner.banner_type == "limited" and rarity in current_banner.featured_units:
		var featured_flag: bool = current_banner.featured_guarantee.get(rarity, false)
		if featured_flag:
			current_banner.featured_guarantee[rarity] = false
			return current_banner.featured_units[rarity][0] # Guaranteed featured
		else:
			if randi() % 100 < 50:
				return current_banner.featured_units[rarity][0] # 50% chance featured
			else:
				current_banner.featured_guarantee[rarity] = true
				return units[0] # Non-featured

	# Standard banner or no featured guarantee
	return units[randi() % units.size()]

func _update_pity(rarity: String) -> void:
	if rarity.to_lower() in ["legendary", "mythic"]:
		player_data.reset_pity(current_banner.id)
	else:
		player_data.increment_pity(current_banner.id)

# -------------------------------------------------
# Builders
# -------------------------------------------------
func _build_companion(data: Dictionary) -> CompanionItem:
	var c := CompanionItem.new()
	c.id = data.get("id", "unknown")
	c.name = data.get("name", "Unknown")
	c.rarity = data.get("rarity", "common")
	c.role = data.get("role", "support")
	c.passive = data.get("passive")
	c.active_ability = data.get("activeAbility")
	c.personality = data.get("personality", "")
	c.level = 1
	return c

func _build_weapon(data: Dictionary) -> WeaponItem:
	var w := WeaponItem.new()
	w.id = data.get("id", "unknown")
	w.name = data.get("name", "Unknown")
	w.rarity = data.get("rarity", "common")
	w.damage = data.get("damage", 0)
	w.fire_rate = data.get("fire_rate", 1.0)
	w.range = data.get("range", 0)
	w.level = 1
	return w

# -------------------------------------------------
# Helper: Rarity Colors for UI
# -------------------------------------------------
func _get_rarity_color(rarity) -> Color:
	var rarity_str: String
	if rarity is Dictionary:
		rarity_str = rarity.get("id", "common")
	else:
		rarity_str = str(rarity)
	match rarity_str.to_lower():
		"common": return Color.WHITE
		"uncommon": return Color.GREEN
		"rare": return Color.BLUE
		"epic": return Color.PURPLE
		"legendary": return Color.GOLD
		"mythic": return Color.ORANGE
		_: return Color.GRAY
