extends Control
class_name ItemDetailPopup

@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var rarity_label: Label = $Panel/VBoxContainer/RarityLabel
@onready var stats_label: Label = $Panel/VBoxContainer/StatsLabel
@onready var desc_label: Label = $Panel/VBoxContainer/DescriptionLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

func show_item(item) -> void:
	name_label.text = item.name
	rarity_label.text = item.rarity.capitalize()
	rarity_label.add_theme_color_override(
		"font_color",
		ColorUtils.rarity_color(item.rarity)
	)

	stats_label.text = _build_stats(item)
	desc_label.text = item.get("description", "")

	show()
	anim.play("open")

func _build_stats(item) -> String:
	if item.has_method("get_stats"):
		return item.get_stats()
	return ""

func _on_close_pressed():
	anim.play("close")
func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "close":
        hide()