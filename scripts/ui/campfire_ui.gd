# ui/CampfireUI.gd
extends Control
class_name CampfireUI

# =====================
# Exports & References
# =====================
@export var banter_manager: BanterManager
@export var gacha_manager: GachaManager
@export var audio_manager: AudioManager

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var speaker_label: Label = $Panel/VBoxContainer/SpeakerLabel
@onready var dialogue_label: RichTextLabel = $Panel/VBoxContainer/DialogueLabel  # Use RichTextLabel for BBCode
@onready var next_button: Button = $Panel/NextButton
@onready var bond_particles: GPUParticles2D = $BondParticles  # Add in scene
@onready var flame_roar: GPUParticles2D = $FlameRoar

# =====================
# Runtime State
# =====================
var current_lines: Array[Dictionary] = []
var current_index: int = 0
var is_typing: bool = false

# =====================
# Public Entry
# =====================
func start_campfire_banter(party: Array[CompanionInstance]) -> void:
	current_lines = banter_manager.get_campfire_lines(party)
	current_index = 0
	
	visible = true
	anim_player.play("open")
	audio_manager.play_campfire_ambient()
	
	if current_lines.is_empty():
		_show_no_banter_message()
	else:
		_show_next_line()

# =====================
# Line Display with Typewriter
# =====================
func _show_next_line() -> void:
	if current_index >= current_lines.size():
		_end_campfire_sequence()
		return
	
	var line = current_lines[current_index]
	speaker_label.text = line.get("speaker", "???")
	
	# Typewriter effect
	dialogue_label.visible_characters = 0
	dialogue_label.text = line.get("text", "")
	is_typing = true
	
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_characters", dialogue_label.text.length(), dialogue_label.text.length() * 0.03)
	tween.tween_callback(func(): is_typing = false)
	
	# Relationship highlight
	if line.has("relationship"):
		_highlight_relationship(line.relationship)
	
	current_index += 1

func _on_NextButton_pressed() -> void:
	if is_typing:
		# Skip typing
		dialogue_label.visible_characters = dialogue_label.text.length()
		is_typing = false
	else:
		_show_next_line()

# =====================
# Visual Feedback
# =====================
func _highlight_relationship(partner_pair: Array) -> void:
	# Flash hearts or glow portraits
	bond_particles.emitting = true
	audio_manager.play_sfx(audio_manager.level_up_sfx, 1.1)

func _show_no_banter_message() -> void:
	speaker_label.text = ""
	dialogue_label.text = "[i]The fire crackles quietly... Your companions rest in comfortable silence.[/i]"
	next_button.text = "Continue"
	next_button.pressed.connect(_end_campfire_sequence, CONNECT_ONE_SHOT)

# =====================
# End Sequence & Rewards
# =====================
func _end_campfire_sequence() -> void:
	anim_player.play("close")
	await anim_player.animation_finished
	
	# Bond growth visual
	_trigger_bond_growth_visual()
	
	# Bonus pull chance
	if randf() < 0.3:  # 30% chance, or based on party bond
		audio_manager.play_campfire_roar()
		flame_roar.emitting = true
		await get_tree().create_timer(1.0).timeout
		_perform_bonus_pull()
	else:
		_show_dust_reward()
	
	visible = false

func _trigger_bond_growth_visual() -> void:
	bond_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	bond_particles.emitting = false

	# Show +Bond for equipped companions
	# Could instance floating text or heart particles

func _perform_bonus_pull() -> void:
	gacha_manager.perform_free_pull()
	# Connect to result and show special popup
	gacha_manager.pull_completed.connect(_on_bonus_pull_result, CONNECT_ONE_SHOT)

func _on_bonus_pull_result(results: Array[Dictionary]) -> void:
	var result = results[0]
	var msg = "The flames grant you...\n[color=gold]%s[/color]!" % result.item.name
	PopupMessage.popup(msg, Color(1, 0.7, 0.3), 5.0)

func _show_dust_reward() -> void:
	var dust = 50 + current_lines.size() * 10
	PlayerData.add_currency("dust", dust)
	PopupMessage.popup("The fire warms your soul...\n+%d Dust" % dust, Color(1, 0.8, 0.4))