# scenes/hub/Hub.gd
extends Node2D

func _ready() -> void:
	$UI/ButtonContainer/GachaButton.pressed.connect(_on_gacha)
	$UI/ButtonContainer/InventoryButton.pressed.connect(_on_inventory)
	$UI/ButtonContainer/CampfireButton.pressed.connect(_on_campfire)
	$UI/ButtonContainer/RunButton.pressed.connect(_on_run)
	$UI/ButtonContainer/QuitButton.pressed.connect(_on_quit)

func _on_gacha() -> void:
	UIManager.open_gacha()

func _on_inventory() -> void:
	UIManager.open_inventory()

func _on_campfire() -> void:
	UIManager.open_campfire()

func _on_run() -> void:
	GameManager.start_mission("mission_01")

func _on_quit() -> void:
	get_tree().quit()