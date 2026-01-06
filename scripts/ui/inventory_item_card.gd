extends PanelContainer
class_name InventoryItemCard

# -------------------------------------------------
# UI References
# -------------------------------------------------
@onready var border: TextureRect = $Border
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var rarity_label: Label = $VBoxContainer/RarityLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

# -------------------------------------------------
# Set item data
# -------------------------------------------------
func set_item(item) -> void:
	name_label.text = item.name
	rarity_label.text = item.rarity.capitalize()
	level_label.text = "Lv. %d" % item.level

	var color := ColorUtils.rarity_color(item.rarity)
	rarity_label.add_theme_color_override("font_color", color)
	border.modulate = color

	# Play glow only for higher rarities
	if ColorUtils.is_rare(item.rarity):
		anim.play("glow")
	else:
		anim.stop()
		border.modulate = Color.white
