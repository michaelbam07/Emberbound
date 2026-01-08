# scenes/ui/GameOverScreen.gd
extends Control

func _ready() -> void:
	$VBoxContainer/ReturnButton.pressed.connect(_on_return)

func _on_return() -> void:
	GameManager.change_state(GameManager.GameState.HUB)