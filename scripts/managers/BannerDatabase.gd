# scripts/managers/BannerDatabase.gd
extends Node
class_name BannerDatabase

@export var banner_resources: Array[BannerBase] = []

var _banners_by_id: Dictionary = {}

func _ready() -> void:
	_rebuild_lookup()
	
	# Optional: auto-load all .tres in folder
	# _auto_load_banners()

func _rebuild_lookup() -> void:
	_banners_by_id.clear()
	for banner in banner_resources:
		if banner and not banner.id.is_empty():
			_banners_by_id[banner.id] = banner
		else:
			push_warning("Invalid banner resource:", banner)

func _auto_load_banners() -> void:
	var dir = DirAccess.open("res://data/banners/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var banner: BannerBase = load("res://data/banners/" + file_name)
				if banner:
					banner_resources.append(banner)
			file_name = dir.get_next()
		_rebuild_lookup()

# =====================
# Public API
# =====================
func get_banner(id: String) -> BannerBase:
	return _banners_by_id.get(id)

func get_active_banners() -> Array[BannerBase]:
	var active = []
	for banner in banner_resources:
		if banner and banner.active:
			active.append(banner)
	return active

func get_banner_pool(id: String) -> Array[String]:
	var banner = get_banner(id)
	return banner.pool if banner else []

func get_rarity_rates(id: String) -> Dictionary:
	var banner = get_banner(id)
	return banner.rarity_rates if banner else {}

func get_pity_rules(id: String) -> Dictionary:
	var banner = get_banner(id)
	return banner.pity if banner else {}

func get_featured(id: String) -> Dictionary:
	var banner = get_banner(id)
	return banner.featured_units if banner else {}