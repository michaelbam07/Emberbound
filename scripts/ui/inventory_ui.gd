# ui/InventoryUI.gd
extends Control
class_name InventoryUI

# =====================
# Signals
# =====================
signal item_selected(item: GachaItem)
signal item_equipped(item: GachaItem)

# =====================
# UI References
# =====================
@onready var grid: GridContainer = $CanvasLayer/Panel/VBoxContainer/ScrollContainer/GridContainer
@onready var tab_bar: TabBar = $CanvasLayer/Panel/VBoxContainer/TabBar
@onready var title_label: Label = $CanvasLayer/Panel/VBoxContainer/TitleLabel
@onready var close_btn: Button = $CanvasLayer/Panel/CloseButton
@onready var sort_option: OptionButton = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SortOption
@onready var search_bar: LineEdit = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SearchBar  # Optional
@onready var stats_label: Label = $CanvasLayer/Panel/VBoxContainer/StatsLabel  # Optional summary

# =====================
# Data & Prefabs
# =====================
var player_data: PlayerData
var item_card_scene: PackedScene = preload("res://ui/InventoryItemCard.tscn")

enum Tab { COMPANIONS, WEAPONS }
var current_tab: int = Tab.COMPANIONS

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	player_data = PlayerData.get_instance()
	
	tab_bar.tab_changed.connect(_on_tab_changed)
	close_btn.pressed.connect(hide)
	
	if sort_option:
		sort_option.item_selected.connect(_refresh_grid)
	if search_bar:
		search_bar.text_changed.connect(_refresh_grid)
	
	# PlayerData signals for live updates
	player_data.companion_added.connect(_refresh_grid)
	player_data.weapon_added.connect(_refresh_grid)
	player_data.companion_leveled_up.connect(_refresh_grid)
	
	_refresh_grid()
	_update_stats_summary()

# =====================
# Core Refresh
# =====================
func _refresh_grid() -> void:
	_clear_grid()
	
	var items := _get_current_items()
	items = _apply_filters(items)
	items = _apply_sort(items)
	
	for item in items:
		var card = item_card_scene.instantiate()
		var is_equipped = _is_item_equipped(item)
		card.set_item(item, is_equipped)
		card.clicked.connect(func(): item_selected.emit(item))
		card.hovered.connect(func(): _show_tooltip(item))
		card.hover_ended.connect(_hide_tooltip)
		grid.add_child(card)
	
	_update_stats_summary()

# =====================
# Data Access
# =====================
func _get_current_items() -> Array[GachaItem]:
	match tab_bar.current_tab:
		Tab.COMPANIONS:
			title_label.text = "Companions (%d)" % player_data.companions.size()
			return player_data.companions
		Tab.WEAPONS:
			title_label.text = "Weapons (%d)" % player_data.weapons.size()
			return player_data.weapons
	return []

func _is_item_equipped(item: GachaItem) -> bool:
	if item is CompanionInstance:
		return item == player_data.get_equipped_companion()
	elif item is WeaponItem:
		return item == player_data.get_equipped_weapon()
	return false

# =====================
# Sort & Filter
# =====================
func _apply_sort(items: Array[GachaItem]) -> Array[GachaItem]:
	if not sort_option:
		return items
	
	var sorted = items.duplicate()
	match sort_option.selected:
		0: # Rarity Descending
			sorted.sort_custom(func(a, b): 
				return ColorUtils.rarity_rank(b.rarity) > ColorUtils.rarity_rank(a.rarity)
			)
		1: # Level Descending
			sorted.sort_custom(func(a, b): return b.level > a.level)
		2: # Name A-Z
			sorted.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)
		3: # Newest First (requires timestamp on pull)
			pass
	return sorted

func _apply_filters(items: Array[GachaItem]) -> Array[GachaItem]:
	var filtered = items.duplicate()
	
	if search_bar and not search_bar.text.is_empty():
		var query = search_bar.text.to_lower()
		filtered = filtered.filter(func(item):
			return item.name.to_lower().contains(query) or \
				   item.flavor_text.to_lower().contains(query)
		)
	
	# Future: rarity filter dropdown, equipped only, etc.
	return filtered

# =====================
# Stats Summary
# =====================
func _update_stats_summary() -> void:
	if not stats_label:
		return
	var text = ""
	match tab_bar.current_tab:
		Tab.COMPANIONS:
			var mythic = player_data.companions.filter(func(c): return c.rarity == "mythic").size()
			text = "Mythic Companions: %d | Total Bond: %d♡" % [
				mythic,
				player_data.companions.reduce(func(acc, c): return acc + c.bond, 0)
			]
		Tab.WEAPONS:
			var max_level = player_data.weapons.reduce(func(acc, w): return max(acc, w.level), 0)
			text = "Highest Level Weapon: Lv.%d | Total Damage Bonus: +%d" % [
				max_level,
				player_data.weapons.reduce(func(acc, w): return acc + (w.level - 1) * w.damage_scaling_per_level, 0)
			]
	stats_label.text = text

# =====================
# Tooltip (Simple)
# =====================
func _show_tooltip(item: GachaItem) -> void:
	# Replace with your TooltipManager or DetailPopup later
	Tooltip.show(item.flavor_text, get_global_mouse_position())

func _hide_tooltip() -> void:
	Tooltip.hide()

# =====================
# Helpers
# =====================
func _clear_grid() -> void:
	for child in grid.get_children():
		child.queue_free()

func _on_tab_changed(tab: int) -> void:
	current_tab = tab
	_refresh_grid()