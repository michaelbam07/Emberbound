extends Node
class_name SaveManager

var player_data: PlayerData

func _ready() -> void:
	player_data = PlayerData.get_instance()

func save_game() -> void:
	player_data.save_data()
	print("Game saved!")

func load_game() -> void:
	player_data.load_data()
	print("Game loaded!")
