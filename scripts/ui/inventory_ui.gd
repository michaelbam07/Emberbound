extends Control
class_name InventoryUI

# -------------------------------------------------
# UI References
# -------------------------------------------------
@onready var grid: GridContainer = $CanvasLayer/Panel/VBoxContainer/ScrollContainer/GridContainer
@onready var tab_bar: TabBar = $CanvasLayer/Panel/VBoxContainer/TabBar
@onready var title_label: Label = $CanvasLayer/Panel/VBoxContainer/TitleLabel
@onready var close_btn: Button = $CanvasLayer/Panel/VBoxContainer/CloseButton
@onready var sort_option: OptionButton = $CanvasLayer/Panel/VBoxContainer/SortOption  # optional dropdown

# -------------------------------------------------
# Data
# -------------------------------------------------
var player_data: PlayerData
var item_card_scene := preload("res://ui/InventoryItemCard.tscn")

# -------------------------------------------------
# Lifecycle
# -------------------------------------------------
func _ready() -> void:
	player_data = PlayerData.get_instance()

	tab_bar.tab_changed.connect(_on_tab_changed)
	close_btn.pressed.connect(hide)
	if sort_option:
		sort_option.item_selected.connect(_refresh)

	_refresh()

# -------------------------------------------------
# Refresh inventory
# -------------------------------------------------
func _refresh() -> void:
	_clear_grid()

	var items := []
	match tab_bar.current_tab:
		0:
			title_label.text = "Companions"
			items = player_data.companions
		1:
			title_label.text = "Weapons"
			items = player_data.weapons

	# Apply sort and filter
	items = _sort_items(items)
	items = _filter_items(items)

	for item in items:
		_add_item_card(item)

# -------------------------------------------------
# Load cards
# -------------------------------------------------
func _add_item_card(item) -> void:
	var card = item_card_scene.instantiate()
	card.set_item(item)
	grid.add_child(card)

# -------------------------------------------------
# Tab Changed
# -------------------------------------------------
func _on_tab_changed(_index: int) -> void:
	_refresh()

# -------------------------------------------------
# Helpers
# -------------------------------------------------
func _clear_grid() -> void:
	for c in grid.get_children():
		c.queue_free()

func _sort_items(items: Array) -> Array:
	if not sort_option:
		return items
	match sort_option.selected:
		0:
			# Sort by rarity descending
			return items.duplicate().sorted(func(a, b):
				return ColorUtils.rarity_rank(b.rarity) - ColorUtils.rarity_rank(a.rarity))
		1:
			# Sort by level descending
			return items.duplicate().sorted(func(a, b):
				return b.level - a.level)
		_:
			return items
	return items

func _filter_items(items: Array) -> Array:
	# Example placeholder: no filter applied yet
	# Later, you could filter by type, equipped status, etc.
	return items
