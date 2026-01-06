# data/config/GameConfigResource.gd
@tool  # Allows editing in Inspector even outside game
extends Resource
class_name GameConfigResource

# =====================
# Screen & Rendering
# =====================
@export_group("Screen Size")
@export var screen_width: int = 1152
@export var screen_height: int = 768

@export_group("Rendering")
@export var pixel_art: bool = true

# =====================
# Debug
# =====================
@export_group("Debug")
@export var debug: bool = false
@export var debug_show_body: bool = false
@export var debug_show_static_body: bool = false
@export var debug_show_velocity: bool = false

# =====================
# Player
# =====================
@export_group("Player")
@export var player_walk_speed: float = 260.0
@export var player_jump_power: float = 800.0
@export var player_gravity_y: float = 1200.0
@export var player_max_health: int = 100
@export var player_hurting_duration_ms: int = 100
@export var player_invulnerable_time_ms: int = 2000
@export var player_attack_damage: int = 40

# =====================
# Enemy
# =====================
@export_group("Enemy")
@export var enemy_walk_speed: float = 100.0
@export var enemy_gravity_y: float = 1200.0
@export var enemy_max_health: int = 60
@export var enemy_attack_damage: int = 20
@export var enemy_attack_cooldown_ms: int = 4000
@export var enemy_patrol_distance: float = 200.0
@export var enemy_detection_range: float = 400.0

# =====================
# Boss
# =====================
@export_group("Boss")
@export var boss_walk_speed: float = 80.0
@export var boss_max_health: int = 200
@export var boss_detection_range: float = 400.0
@export var boss_attack_range: float = 120.0
@export var boss_attack_cooldown_ms: int = 2000
@export var boss_shoot_cooldown_ms: int = 2000
@export var boss_shoot_range: float = 600.0
@export var boss_attack_damage: int = 40
@export var boss_hurting_duration_ms: int = 100
@export var boss_invulnerable_time_ms: int = 1000

# =====================
# Map
# =====================
@export_group("Map")
@export var tile_size: int = 64

# =====================
# Keybinds (use InputEventKey for real remapping later)
# =====================
@export_group("Keybinds")
@export var key_up: String = "UP"
@export var key_down: String = "DOWN"
@export var key_left: String = "LEFT"
@export var key_right: String = "RIGHT"
@export var key_wasd_up: String = "W"
@export var key_wasd_down: String = "S"
@export var key_wasd_left: String = "A"
@export var key_wasd_right: String = "D"
@export var key_shoot: String = "J"
@export var key_melee: String = "K"
@export var key_interact: String = "K"

# =====================
# Game Settings
# =====================
@export_group("Game Settings")
@export var selected_character: String = "elite_soldier"