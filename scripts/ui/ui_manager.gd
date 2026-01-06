extends Node
class_name UIManager

static var instance: UIManager = null

func _ready():
    instance = self

static func get_instance() -> UIManager:
    return instance

# -------------------------------------------------
# UI References
# -------------------------------------------------
@onready var popup_manager: PopupManager = $PopupManager
@onready var hud: Control = $HUD
@onready var inventory_panel: Control = $InventoryPanel
@onready var banner_panel: Control = $BannerPanel

# -------------------------------------------------
# Popup Messages
# -------------------------------------------------
func show_popup(text: String, color: Color = Color.WHITE) -> void:
	popup_manager.show(text, color)

# -------------------------------------------------
# HUD Updates
# -------------------------------------------------
func update_currency(type: String, amount: int) -> void:
	if hud.has_node(type):
		var label = hud.get_node(type) as Label
		label.text = str(amount)

func update_level(level: int) -> void:
	if hud.has_node("LevelLabel"):
		var label = hud.get_node("LevelLabel") as Label
		label.text = "Lv. " + str(level)

# -------------------------------------------------
# Inventory Panel
# -------------------------------------------------
func open_inventory() -> void:
	inventory_panel.show()

func close_inventory() -> void:
	inventory_panel.hide()

# -------------------------------------------------
# Banner Panel
# -------------------------------------------------
func open_banner(banner_id: String) -> void:
	banner_panel.show()
	if banner_panel.has_method("set_banner"):
		banner_panel.call("set_banner", banner_id)

func close_banner() -> void:
	banner_panel.hide()
