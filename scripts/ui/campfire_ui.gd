extends Control
class_name CampfireUI

@export var banter_manager: BanterManager
@export var animation_player_path := "AnimationPlayer"

# Runtime
var lines: Array = []
var index := 0
var gacha_manager: GachaManager
var anim: AnimationPlayer

func _ready() -> void:
	anim = $AnimationPlayer
	gacha_manager = get_node("/root/GachaManager")
	$Panel/NextButton.pressed.connect(_on_NextButton_pressed)
	hide()

# -------------------------------------------------
# Start a campfire banter sequence
# -------------------------------------------------
func start_banter(party: Array) -> void:
	lines = banter_manager.get_campfire_banter(party)
	index = 0
	show()
	anim.play("open")
	_show_line()

# -------------------------------------------------
# Display a single line
# -------------------------------------------------
func _show_line() -> void:
	if index >= lines.size():
		_end_banter()
		return

	var line = lines[index]
	$Panel/VBoxContainer/SpeakerLabel.text = line.get("speaker", "???")
	$Panel/VBoxContainer/DialogueLabel.text = line.get("text", "")

	# Optional: animate text appearing
	var dlg_anim = AnimationPlayer.new()
	# Could add a typewriter effect here
	# For now just ensure panel is visible
	$Panel.visible = true

# -------------------------------------------------
# Next line
# -------------------------------------------------
func _on_NextButton_pressed() -> void:
	index += 1
	_show_line()

# -------------------------------------------------
# End banter
# -------------------------------------------------
func _end_banter() -> void:
	anim.play("close")
	yield(anim, "animation_finished")
	hide()

	# Optional: trigger bonus pull at campfire
	_bonus_pull()

# -------------------------------------------------
# Example: bonus pull trigger
# -------------------------------------------------
func _bonus_pull() -> void:
	# Guaranteed 4★+ companion
	var item = gacha_manager.pull_companion()  
	print("Bonus pull reward:", item.name)
	# Optional: show popup
	var popup_mgr = get_node("/root/PopupManager")
	popup_mgr.show("Campfire Pull: %s" % item.name, Color.gold)
