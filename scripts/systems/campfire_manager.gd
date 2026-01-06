extends Node
class_name CampfireManager

@export var banter_manager: BanterManager
@export var campfire_ui: CampfireUI

var party: Array = []

func start_campfire(party_members: Array) -> void:
	party = party_members
	campfire_ui.start_banter(party)
	campfire_ui.show()
	AudioManager.play_sfx(AudioManager.campfire_sfx)
func end_campfire() -> void:
    campfire_ui.hide()