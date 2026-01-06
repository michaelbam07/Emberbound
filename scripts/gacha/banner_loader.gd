extends Node
class_name BannerLoader

@export var banner_json_path: String = "res://data/banner.json"

# banner_id -> banner data dictionary
var banners: Dictionary = {}

func _ready() -> void:
	load_banners()

# -------------------------------------------------
# Load & Parse
# -------------------------------------------------
func load_banners() -> void:
	var file := FileAccess.open(banner_json_path, FileAccess.READ)
	if not file:
		push_error("BannerLoader: Failed to open banner.json")
		return

	var json := JSON.parse(file.get_as_text())
	file.close()

	if json.error != OK:
		push_error("BannerLoader: Invalid JSON")
		return

	var data := json.result
	if not data.has("banners"):
		push_error("BannerLoader: Missing 'banners' array")
		return

	banners.clear()
	for banner in data["banners"]:
		if banner.has("id"):
			banners[banner["id"]] = banner

# -------------------------------------------------
# Accessors
# -------------------------------------------------
func get_banner(banner_id: String) -> Dictionary:
	return banners.get(banner_id, {})

func get_active_banners() -> Array:
	var result := []
	for banner in banners.values():
		if banner.get("active", false):
			result.append(banner)
	return result

func get_banner_pool(banner_id: String) -> Array:
	var banner := get_banner(banner_id)
	return banner.get("pool", [])

func get_rarity_rates(banner_id: String) -> Dictionary:
	var banner := get_banner(banner_id)
	return banner.get("rarity_rates", {})

func get_pity_rules(banner_id: String) -> Dictionary:
	var banner := get_banner(banner_id)
	return banner.get("pity", {})

func get_featured(banner_id: String) -> Dictionary:
	var banner := get_banner(banner_id)
	return banner.get("featured", {})
