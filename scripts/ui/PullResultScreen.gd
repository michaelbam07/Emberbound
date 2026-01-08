# ui/PullResultScreen.gd
extends Control

signal reveal_completed

@export var card_scene: PackedScene = preload("res://ui/PullResultCard.tscn")
@onready var card_container: HBoxContainer = $CardContainer
@onready var continue_button: Button = $ContinueButton
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var current_results: Array[Dictionary] = []
var current_index: int = 0

func prepare_results(results: Array[Dictionary]) -> void:
	current_results = results
	_create_cards()

func _create_cards() -> void:
	for i in 10:
		var card = card_scene.instantiate()
		card_container.add_child(card)
		card.setup_back()  # Show back initially

func start_reveal_sequence() -> void:
	anim_player.play("summon_ritual")
	await anim_player.animation_finished
	
	_reveal_next_card()

func _reveal_next_card() -> void:
	if current_index >= current_results.size():
		_finale()
		return
	
	var result = current_results[current_index]
	var card = card_container.get_child(current_index)
	
	card.reveal(result)
	
	# Rarity-specific effects
	match result.rarity:
		"mythic":
			anim_player.play("mythic_nova")
			audio_player.stream = result.item.voice_line  # Companion voice!
			audio_player.play()
			await get_tree().create_timer(1.0).timeout
		"legendary":
			anim_player.play("legendary_flash")
		"epic":
			anim_player.play("epic_burst")
	
	# Dupe level-up
	if not result.is_new:
		anim_player.play("level_up_burst")
	
	current_index += 1
	await get_tree().create_timer(1.2).timeout  # Suspense!
	_reveal_next_card()

func _finale() -> void:
	continue_button.visible = true
	continue_button.grab_focus()
	anim_player.play("finale_glow")
	AudioManager.play_campfire_roar()

func _on_ContinueButton_pressed() -> void:
	reveal_completed.emit()