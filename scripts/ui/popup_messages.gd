# ui/PopupMessage.gd
extends Control
class_name PopupMessage

# =====================
# Signals
# =====================
signal finished  # Emitted when fully hidden and ready for cleanup

# =====================
# Exports
# =====================
@export var display_time: float = 3.0          # Total visible time
@export var float_distance: float = 80.0       # How far it floats up
@export var pop_in_scale: Vector2 = Vector2(0.8, 0.8)
@export var float_ease: Tween.TransitionType = Tween.TRANS_QUART
@export var fade_ease: Tween.EaseType = Tween.EASE_OUT

# Optional icon (for achievements, currency, etc.)
@export var icon_texture: Texture2D

# =====================
# References
# =====================
@onready var panel: PanelContainer = $Panel
@onready var icon: TextureRect = $Panel/Icon
@onready var label: RichTextLabel = $Panel/MessageLabel  # Use RichTextLabel for BBCode
@onready var tween: Tween

# =====================
# State
# =====================
var active: bool = false

# =====================
# Public API
# =====================
func show_message(
	text: String,
	text_color: Color = Color(1, 0.9, 0.7),
	duration: float = -1.0,
	icon_tex: Texture2D = null
) -> void:
	if active:
		return  # Prevent overlap on same instance
	
	if duration > 0:
		display_time = duration
	
	label.text = text
	label.add_theme_color_override("default_color", text_color)
	
	if icon_tex or icon_texture:
		icon.texture = icon_tex if icon_tex else icon_texture
		icon.visible = true
	else:
		icon.visible = false
	
	# Reset state
	modulate.a = 0.0
	scale = pop_in_scale
	position = position  # Ensure start pos
	
	visible = true
	active = true
	
	_play_animation()

# =====================
# Animation Sequence
# =====================
func _play_animation() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	
	# Pop in
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	
	# Float up
	tween.tween_property(self, "position:y", position.y - float_distance, display_time)\
		.set_trans(float_ease).set_ease(Tween.EASE_OUT)
	
	# Hold full opacity
	tween.tween_interval(display_time - 0.7)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, 0.5)\
		.set_ease(fade_ease)
	
	tween.tween_callback(_on_complete)

# =====================
# Completion
# =====================
func _on_complete() -> void:
	active = false
	visible = false
	finished.emit()
	# Optional: queue_free() if not pooled

# =====================
# Quick Helpers (Call from anywhere)
# =====================
static func popup(text: String, color: Color = Color(1, 0.9, 0.7), duration: float = 3.0) -> void:
	var scene = preload("res://ui/PopupMessage.tscn")
	var instance = scene.instantiate()
	instance.show_message(text, color, duration)
	get_tree().current_scene.add_child(instance)