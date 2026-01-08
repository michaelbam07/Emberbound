# scenes/loading/LoadingScreen.gd
extends Control

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar

func _ready() -> void:
	# Simulate loading
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 100, 3.0)
	tween.tween_callback(func(): GameManager.change_state(GameManager.GameState.HUB))