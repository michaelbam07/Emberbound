# res://core/GameManager.gd
extends Node

"""
GameManager.gd
-----------------
Global game state manager.
- Loads config from JSON
- Handles hub and mission scene transitions
- Supports debug mode and headless testing
- Hooks for gacha, companions, dialogue
"""

# Enum for game states
enum GameState {
    LOADING,
    HUB,
    MISSION,
    VICTORY,
    GAME_OVER,
    GAME_COMPLETE
}

# Current game state
var current_state: GameState = GameState.LOADING

# Loaded config data
var config: Dictionary = {}

# Current mission (optional)
var current_mission: String = ""

# Debug mode
var debug_enabled: bool = true

# Signals (optional hooks for systems)
signal state_changed(new_state: GameState)
signal mission_started(mission_name: String)
signal mission_completed(mission_name: String)

# -----------------------------
# INITIALIZATION
# -----------------------------
func _init():
    load_config()
    change_state(GameState.LOADING)

# -----------------------------
# CONFIG LOADING
# -----------------------------
func load_config(path: String = "res://data/gameConfig.json") -> void:
    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var raw = file.get_as_text()
        var result = JSON.parse_string(raw)
        if result == null:
            push_error("JSON parse error")
            config = {}
        else:
            config = result
            debug_enabled = config.get("debugConfig", {}).get("debug", {}).get("value", true)
            if debug_enabled:
                print("Config loaded successfully")
    else:
        push_error("Config file not found: " + path)
        config = {}

# -----------------------------
# GAME STATE MANAGEMENT
# -----------------------------
func change_state(new_state: GameState) -> void:
    current_state = new_state
    emit_signal("state_changed", current_state)
    
    if debug_enabled:
        print("Game state changed to:", str(current_state))

    match new_state:
        GameState.LOADING:
            _change_scene("res://scenes/loading/loading.tscn")
        GameState.HUB:
            _change_scene("res://scenes/hub/hub.tscn")
        GameState.MISSION:
            if current_mission != "":
                _change_scene("res://scenes/mission/" + current_mission + ".tscn")
            else:
                push_error("No mission selected!")
        GameState.VICTORY:
            _change_scene("res://scenes/ui/victory_ui.tscn")
        GameState.GAME_OVER:
            _change_scene("res://scenes/ui/game_over_ui.tscn")
        GameState.GAME_COMPLETE:
            _change_scene("res://scenes/ui/game_complete_ui.tscn")

# -----------------------------
# SCENE MANAGEMENT
# -----------------------------
func _change_scene(path: String) -> void:
    if get_tree().current_scene:
        get_tree().current_scene.queue_free()
    var scene_res = load(path)
    if scene_res:
        var scene_instance = scene_res.instantiate()
        get_tree().root.add_child(scene_instance)
        get_tree().current_scene = scene_instance
        if debug_enabled:
            print("Scene changed to:", path)
    else:
        push_error("Failed to load scene: " + path)

# -----------------------------
# MISSION MANAGEMENT
# -----------------------------
func start_mission(mission_name: String) -> void:
    current_mission = mission_name
    emit_signal("mission_started", mission_name)
    change_state(GameState.MISSION)

func complete_mission(success: bool = true) -> void:
    emit_signal("mission_completed", current_mission)
    current_mission = ""
    if success:
        change_state(GameState.VICTORY)
    else:
        change_state(GameState.GAME_OVER)

# -----------------------------
# HELPER METHODS
# -----------------------------
func is_in_state(state: GameState) -> bool:
    return current_state == state

func get_player_config(key: String):
    return config.get("playerConfig", {}).get(key, {}).get("value", null)

func get_enemy_config(key: String):
    return config.get("enemyConfig", {}).get(key, {}).get("value", null)

func get_boss_config(key: String):
    return config.get("bossConfig", {}).get(key, {}).get("value", null)

func get_key_mapping(key: String):
    return config.get("keyConfig", {}).get(key, {}).get("value", null)
