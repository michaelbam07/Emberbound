extends Node
class_name Main

# References to core systems
@onready var gacha_manager: GachaManager = $GachaManager
@onready var player_data: PlayerData = $PlayerData
@onready var ui_manager: UIManager = $UIManager
@onready var gacha_ui: GachaUI = $GachaUI
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var campfire_ui: CampfireUI = $CampfireUI

# -------------------------------------------------
# Lifecycle
# -------------------------------------------------
func _ready() -> void:
	# Load player data
	player_data.load_data()

	# Optional: open starting banner
	# var banner = gacha_manager.standard_companion_banner
	# gacha_ui.open_banner(banner)

	# Hide UI panels initially
	inventory_ui.hide()
	campfire_ui.hide()
	gacha_ui.hide()

	# Example: connect global input
	# Input handling in _input

# -------------------------------------------------
# Global Input (example)
# -------------------------------------------------
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_I:
				if inventory_ui.visible:
					inventory_ui.hide()
				else:
					inventory_ui.show()
			KEY_G:
				# Open gacha UI for standard companion banner
				var banner = gacha_manager.standard_companion_banner
				gacha_ui.open_banner(banner)
			KEY_C:
				# Open campfire UI
				var party = ["Alice", "Bob", "Charlie"]  # Example
				campfire_ui.start_banter(party)
				campfire_ui.show()
