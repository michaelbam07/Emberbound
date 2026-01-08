# scripts/managers/GameManager.gd
extends Node
class_name GameManager

# =====================
# Singleton Safety
# =====================
static var instance: GameManager = null

func _ready() -> void:
	if instance == null:
		instance = self
	else:
		queue_free()
		return

# =====================
# Enums & Signals
# =====================
enum GameState {
	LOADING,
	HUB,
	MISSION,
	VICTORY,
	GAME_OVER,
	GAME_COMPLETE
}

var current_state: GameState = GameState.LOADING :
	set(value):
		if current_state != value:
			current_state = value
			state_changed.emit(current_state)
			if debug_enabled:
				print("Game state → %s" % GameState.keys()[current_state])

signal state_changed(new_state: GameState)
signal mission_started(mission_name: String)
signal mission_completed(mission_name: String, success: bool)
signal game_initialized()

# =====================
# Config & Debug
# =====================
var config: Dictionary = {}
var debug_enabled: bool = false

const CONFIG_PATH: String = "res://data/gameConfig.json"

# =====================
# Mission State
# =====================
var current_mission: String = ""

# =====================
# Initialization
# =====================
func _init() -> void:
	load_config()
	change_state(GameState.LOADING)
	game_initialized.emit()

func load_config(path: String = CONFIG_PATH) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("GameManager: Config file not found: %s" % path)
		config = {}
		return
	
	var content = file.get_as_text()
	file.close()
	
	var parse = JSON.new()
	var error = parse.parse(content)
	if error != OK:
		push_error("GameManager: Invalid config JSON — %s" % parse.get_error_message())
		config = {}
		return
	
	config = parse.data
	debug_enabled = config.get("debugConfig", {}).get("debug", {}).get("value", false)

# =====================
# State Machine
# =====================
func change_state(new_state: GameState) -> void:
	current_state = new_state

	match new_state:
		GameState.LOADING:
			load_scene("res://scenes/loading/LoadingScreen.tscn")
		GameState.HUB:
			load_scene("res://scenes/hub/Hub.tscn")
		GameState.MISSION:
			if current_mission.is_empty():
				push_error("GameManager: Cannot start mission — no mission selected!")
				change_state(GameState.HUB)
			else:
				load_scene("res://scenes/missions/%s.tscn" % current_mission)
		GameState.VICTORY:
			load_scene("res://scenes/ui/VictoryScreen.tscn")
		GameState.GAME_OVER:
			load_scene("res://scenes/ui/GameOverScreen.tscn")
		GameState.GAME_COMPLETE:
			load_scene("res://scenes/ui/GameCompleteScreen.tscn")

# =====================
# Scene Management
# =====================
func load_scene(path: String) -> void:
	var resource = load(path)
	if not resource:
		push_error("GameManager: Failed to load scene: %s" % path)
		return
	
	# Clean current scene
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	var new_scene = resource.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	if debug_enabled:
		print("Scene loaded: %s" % path)

# =====================
# Mission Flow
# =====================
func start_mission(mission_name: String) -> void:
	current_mission = mission_name
	mission_started.emit(mission_name)
	change_state(GameState.MISSION)

func complete_mission(success: bool = true) -> void:
	if current_mission.is_empty():
		return
	
	mission_completed.emit(current_mission, success)
	var old_mission = current_mission
	current_mission = ""
	
	if success:
		change_state(GameState.VICTORY)
	else:
		change_state(GameState.GAME_OVER)

# =====================
# Query Helpers
# =====================
func is_in_state(state: GameState) -> bool:
	return current_state == state

func is_in_hub() -> bool:
	return current_state == GameState.HUB

func is_in_mission() -> bool:
	return current_state == GameState.MISSION

# =====================
# Config Accessors (Safe)
# =====================
func get_config(path: String, default = null):
	var keys = path.split(".")
	var value = config
	for key in keys:
		if value is Dictionary and value.has(key):
			value = value[key]
		else:
			return default
	return value.get("value", value) if value is Dictionary else value

# Examples:
# get_config("playerConfig.walkSpeed")
# get_config("keyConfig.shoot")
# get_config("renderConfig.pixelArt")

# =====================
# Debug Helpers
# =====================
func debug_skip_to_hub() -> void:
	if debug_enabled:
		change_state(GameState.HUB)

func debug_win_mission() -> void:
	if debug_enabled and is_in_mission():
		complete_mission(true)