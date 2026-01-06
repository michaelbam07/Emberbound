extends Node
class_name PopupManager

# -------------------------------------------------
# Config
# -------------------------------------------------
@export var popup_scene_path := "res://scenes/ui/popup_message.tscn"
@export var spacing := 10                # pixels between stacked popups
@export var max_popups := 3              # max concurrent popups

# -------------------------------------------------
# Internal State
# -------------------------------------------------
var popup_scene: PackedScene
var active_popups := []   # Array of PopupMessage instances
var message_queue := []   # Array of dictionaries {text, color}

# -------------------------------------------------
# Lifecycle
# -------------------------------------------------
func _ready() -> void:
	popup_scene = preload(popup_scene_path)

# -------------------------------------------------
# Public API
# -------------------------------------------------
func show(text: String, color: Color = Color.white) -> void:
	# Add message to queue
	var msg := {"text": text, "color": color}
	message_queue.append(msg)
	_process_queue()

# -------------------------------------------------
# Queue processing
# -------------------------------------------------
func _process_queue() -> void:
	# Spawn new popups if under limit
	while message_queue.size() > 0 and active_popups.size() < max_popups:
		var msg_data = message_queue.pop_front()
		_spawn_popup(msg_data.text, msg_data.color)

# -------------------------------------------------
# Spawn a popup instance
# -------------------------------------------------
func _spawn_popup(text: String, color: Color) -> void:
	var popup: PopupMessage = popup_scene.instantiate()
	popup.show_message(text, color)

	# Add to UI (use a CanvasLayer in your scene for proper overlay)
	if get_tree().current_scene.has_node("UIRoot/PopupLayer"):
		get_node("/root/UIRoot/PopupLayer").add_child(popup)
	else:
		# fallback: add to current scene
		get_tree().current_scene.add_child(popup)

	active_popups.append(popup)

	# Connect to hide signal (popup exits tree)
	popup.connect("tree_exited", Callable(self, "_on_popup_closed"), [popup])

	# Update stacked positions
	_update_positions()

# -------------------------------------------------
# Popup closed callback
# -------------------------------------------------
func _on_popup_closed(popup: PopupMessage) -> void:
	if popup in active_popups:
		active_popups.erase(popup)
		_update_positions()
		_process_queue()  # Spawn next message if queued

# -------------------------------------------------
# Stack active popups visually
# -------------------------------------------------
func _update_positions() -> void:
	# Base Y (bottom of screen minus offset)
	var base_y := ProjectSettings.get_setting("display/window/size/height") - 100

	for i in range(active_popups.size()):
		var p = active_popups[i]
		# X = 50px from left, stack upward
		p.rect_position = Vector2(50, base_y - i * (p.rect_size.y + spacing))
