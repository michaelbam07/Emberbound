extends Control
class_name PopupMessage

signal finished  # Emitted when the popup finishes

@export var display_time := 2.0     # seconds popup stays on screen
@export var move_distance := 50.0   # pixels it floats upward

var timer := 0.0
var velocity := Vector2.ZERO
var start_position := Vector2.ZERO
var label: Label
var active := false  # whether the popup is currently visible

func _ready() -> void:
	label = $Panel/MessageLabel
	hide()
	modulate.a = 1.0  # start fully visible

func show_message(text: String, color: Color = Color.WHITE) -> void:
	label.text = text
	label.add_color_override("font_color", color)
	show()
	start_position = position
	timer = display_time
	modulate.a = 1.0
	velocity = Vector2(0, -move_distance / display_time)  # float upward
	active = true

func _process(delta: float) -> void:
	if not active:
		return

	# Move popup upward
	position += velocity * delta

	# Fade out smoothly
	timer -= delta
	if timer <= 0:
		_reset()
	else:
		modulate.a = timer / display_time

func _reset() -> void:
	hide()
	position = start_position
	modulate.a = 1.0
	active = false
	emit_signal("finished")  # Notify PopupManager that it's done
