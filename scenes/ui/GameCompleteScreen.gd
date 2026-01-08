# scenes/ui/GameCompleteScreen.gd
extends Control

func _ready() -> void:
	$VBoxContainer/NewGamePlusButton.pressed.connect(_on_new_game_plus)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit)

func _on_new_game_plus() -> void:
	GameManager.debug_skip_to_hub()  # Or reset with NG+ flags

func _on_quit() -> void:
	get_tree().reload_current_scene()