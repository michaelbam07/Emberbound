# scripts/managers/UIManager.gd
extends Node
class_name UIManager

# =====================
# Singleton
# =====================
static var instance: UIManager = null

func _ready() -> void:
	if instance == null:
		instance = self
	else:
		queue_free()  # Prevent duplicates

static func get_instance() -> UIManager:
	return instance

# =====================
# Signals (For animation/flow control)
# =====================
signal screen_opened(screen_name: String)
signal screen_closed(screen_name: String)
signal popup_shown(text: String)

# =====================
# UI References
# =====================
@onready var popup_manager: PopupManager = $PopupLayer/PopupManager
@onready var hud: Control = $HUD
@onready var inventory_ui: Control = $InventoryUI
@onready var gacha_ui: Control = $GachaUI
@onready var campfire_ui: Control = $CampfireUI
@onready var item_detail_popup: ItemDetailPopup = $ItemDetailPopup

# Optional dim background for modals
@onready var dim_background: ColorRect = $DimBackground

# Current open screens stack (for back button later)
var open_screens: Array[String] = []

# =====================
# Popup Messages
# =====================
func show_popup(text: String, color: Color = Color(1, 0.9, 0.7), duration: float = 3.0) -> void:
	popup_manager.show(text, color, duration)
	popup_shown.emit(text)

func show_success(text: String) -> void:
	popup_manager.show_success(text)

func show_warning(text: String) -> void:
	popup_manager.show_warning(text)

func show_error(text: String) -> void:
	popup_manager.show_error(text)

# =====================
# HUD Updates
# =====================
func update_currency(type: String, amount: int) -> void:
	var label_path = "Currencies/" + type.capitalize() + "Label"
	if hud.has_node(label_path):
		hud.get_node(label_path).text = str(amount)

func update_level(level: int) -> void:
	if hud.has_node("LevelLabel"):
		hud.get_node("LevelLabel").text = "Lv. %d" % level

func update_dust(amount: int) -> void:
	update_currency("dust", amount)

# =====================
# Screen Management
# =====================
func open_inventory() -> void:
	_open_screen(inventory_ui, "inventory")

func close_inventory() -> void:
	_close_screen(inventory_ui, "inventory")

func open_gacha() -> void:
	_open_screen(gacha_ui, "gacha")

func close_gacha() -> void:
	_close_screen(gacha_ui, "gacha")

func open_campfire() -> void:
	_open_screen(campfire_ui, "campfire")

func close_campfire() -> void:
	_close_screen(campfire_ui, "campfire")

func show_item_detail(item: GachaItem) -> void:
	item_detail_popup.show_item(item)
	dim_background.visible = true

func close_item_detail() -> void:
	item_detail_popup.visible = false
	dim_background.visible = false

# =====================
# Private Screen Helpers
# =====================
func _open_screen(screen: Control, name: String) -> void:
	if open_screens.has(name):
		return
	screen.visible = true
	dim_background.visible = true
	open_screens.append(name)
	screen_opened.emit(name)

func _close_screen(screen: Control, name: String) -> void:
	if not open_screens.has(name):
		return
	screen.visible = false
	open_screens.erase(name)
	if open_screens.is_empty():
		dim_background.visible = false
	screen_closed.emit(name)

func close_all_screens() -> void:
	for screen_name in open_screens.duplicate():
		match screen_name:
			"inventory": close_inventory()
			"gacha": close_gacha()
			"campfire": close_campfire()

# =====================
# Banner Shortcut (Legacy support)
# =====================
func open_banner(banner_id: String) -> void:
	open_gacha()
	gacha_ui.open_with_banner(BannerManager.get_instance().get_banner(banner_id))

# =====================
# Animation Helpers (Optional)
# =====================
func play_global_animation(anim_name: String) -> void:
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play(anim_name)