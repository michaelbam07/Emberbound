# scenes/Main.gd
extends Node
class_name Main

# =====================
# Core Systems
# =====================
@onready var gacha_manager: GachaManager = $GachaManager
@onready var player_data: PlayerData = $PlayerData
@onready var ui_manager: UIManager = $UIManager
@onready var audio_manager: AudioManager = $AudioManager
@onready var gacha_ui: GachaUI = $GachaUI
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var campfire_ui: CampfireUI = $CampfireUI

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	# Load saved progress
	player_data.load_data()
	
	# Start ambient music
	audio_manager.play_music(audio_manager.menu_music, 2.0)
	
	# Hide all overlay UI
	ui_manager.close_all_screens()
	
	# Optional: Auto-open gacha on first launch
	if player_data.is_new_player():  # Add this flag
		var starting_banner = BannerManager.get_instance().get_banner("std_companion_001")
		gacha_ui.open_with_banner(starting_banner)
	
	# Debug input
	if OS.is_debug_build():
		print("Emberbound ready — press I (Inventory), G (Gacha), C (Campfire)")

# =====================
# Global Input (Debug & Quick Access)
# =====================
func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	
	match event.keycode:
		KEY_I:
			if inventory_ui.visible:
				ui_manager.close_inventory()
			else:
				ui_manager.open_inventory()
				audio_manager.play_sfx(audio_manager.inventory_open_sfx)
		
		KEY_G:
			var banner = BannerManager.get_instance().get_active_banner() or BannerManager.get_instance().get_banner("std_companion_001")
			ui_manager.open_gacha()
			gacha_ui.open_with_banner(banner)
			audio_manager.play_sfx(audio_manager.button_click_sfx)
		
		KEY_C:
			var party = player_data.get_equipped_companions()
			if party.size() >= 2:
				ui_manager.open_campfire()
				campfire_ui.start_campfire_banter(party)
				audio_manager.play_campfire_ambient()
			else:
				ui_manager.show_popup("Need at least 2 companions for campfire!", Color.ORANGE)

		KEY_ESCAPE:
			if ui_manager.open_screens.size() > 0:
				ui_manager.close_all_screens()
			else:
				# Optional: pause menu or quit confirm
				pass