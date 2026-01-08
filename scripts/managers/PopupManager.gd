# scripts/managers/PopupManager.gd
extends Node
class_name PopupManager

# =====================
# Config
# =====================
@export var popup_scene: PackedScene = preload("res://ui/PopupMessage.tscn")
@export var popup_layer_path: NodePath = "/root/UIRoot/CanvasLayer/PopupLayer"  # Your overlay layer
@export var max_concurrent: int = 4
@export var vertical_spacing: float = 15.0
@export var bottom_offset: float = 100.0
@export var default_duration: float = 3.0
@export var slide_in_duration: float = 0.3
@export var slide_out_duration: float = 0.4

# Priority messages skip queue
@export var priority_duration_multiplier: float = 1.5

# =====================
# Internal State
# =====================
var popup_container: Node
var active_popups: Array[Control] = []
var message_queue: Array[Dictionary] = []  # {text: String, color: Color, duration: float, priority: bool}

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	popup_container = get_node(popup_layer_path)
	if not popup_container:
		push_warning("PopupManager: Popup layer not found at %s — falling back to current scene" % popup_layer_path)
		popup_container = get_tree().current_scene

# =====================
# Public API
# =====================
func show(text: String, color: Color = Color(1, 0.9, 0.7), duration: float = -1.0, priority: bool = false) -> void:
	var msg = {
		"text": text,
		"color": color,
		"duration": default_duration if duration < 0 else duration,
		"priority": priority
	}
	
	if priority:
		message_queue.insert(0, msg)  # Front of queue
	else:
		message_queue.append(msg)
	
	_process_queue()

func show_success(text: String) -> void:
	show(text, Color(0.3, 1, 0.3), default_duration * 1.2)

func show_warning(text: String) -> void:
	show(text, Color(1, 0.8, 0.2), default_duration * 1.3)

func show_error(text: String) -> void:
	show(text, Color(1, 0.3, 0.3), default_duration * 1.5, true)

# =====================
# Queue Processing
# =====================
func _process_queue() -> void:
	while active_popups.size() < max_concurrent and not message_queue.is_empty():
		var msg = message_queue.pop_front()
		_spawn_popup(msg)

# =====================
# Spawn Popup
# =====================
func _spawn_popup(data: Dictionary) -> void:
	var popup: PopupMessage = popup_scene.instantiate()
	popup.show_message(data.text, data.color, data.duration)
	
	popup_container.add_child(popup)
	active_popups.append(popup)
	
	# Connect cleanup
	popup.tree_exited.connect(_on_popup_closed.bind(popup))
	
	# Position
	_update_popup_positions()

# =====================
# Cleanup & Reposition
# =====================
func _on_popup_closed(popup: Control) -> void:
	if popup in active_popups:
		active_popups.erase(popup)
		_update_popup_positions()
		_process_queue()

func _update_popup_positions() -> void:
	var screen_height = get_viewport().get_visible_rect().size.y
	var base_y = screen_height - bottom_offset
	
	for i in range(active_popups.size()):
		var p = active_popups[i]
		var target_y = base_y - i * (p.size.y + vertical_spacing)
		var tween = create_tween()
		tween.tween_property(p, "position:y", target_y, slide_in_duration)
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

# =====================
# Clear All (For scene changes)
# =====================
func clear_all() -> void:
	for popup in active_popups:
		if is_instance_valid(popup):
			popup.queue_free()
	active_popups.clear()
	message_queue.clear()