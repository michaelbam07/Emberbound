# scripts/managers/GameConfig.gd
extends Node

@export var config: GameConfigResource

@onready var instance: GameConfigResource = config

func _ready() -> void:
	if config == null:
		push_error("GameConfig resource not assigned!")
	else:
		# Apply settings if needed (e.g., window size)
		DisplayServer.window_set_size(Vector2i(config.screen_width, config.screen_height))

# Easy global access
static func get_value(path: String):
	return GameConfig.instance.get(path)