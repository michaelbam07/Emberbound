# scripts/managers/BannerManager.gd
extends Node
class_name BannerManager

@export var all_banners: Array[GachaBanner] = []
# ... rest stays the same!

var _banners_by_id: Dictionary = {}

var active_banner_id: String = "" :
	set(value):
		if value == active_banner_id:
			return
		var banner = _banners_by_id.get(value)
		if banner and banner.active:
			active_banner_id = value
			active_banner_changed.emit(banner)
		else:
			push_error("BannerManager: Cannot activate banner '%s' — invalid or not active" % value)

signal active_banner_changed(banner: BannerBase)
signal banner_list_updated()

func _ready() -> void:
	_rebuild_lookup()
	_select_first_active()

func _rebuild_lookup() -> void:
	_banners_by_id.clear()
	for banner in all_banners:
		if banner and not banner.id.is_empty():
			if _banners_by_id.has(banner.id):
				push_warning("Duplicate banner ID: %s" % banner.id)
			_banners_by_id[banner.id] = banner
		else:
			push_warning("Invalid banner resource (missing ID): %s" % banner)
	banner_list_updated.emit()

# Optional auto-load — call once or in _ready() if preferred
func auto_load_banners(folder_path: String = "res://data/banners/") -> void:
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var banner: BannerBase = load(folder_path + file_name)
				if banner and not banner.id.is_empty():
					all_banners.append(banner)
			file_name = dir.get_next()
		_rebuild_lookup()
		_select_first_active()

func _select_first_active() -> void:
	var active_banners = get_active_banners()
	if not active_banners.is_empty() and active_banner_id.is_empty():
		active_banner_id = active_banners[0].id

# =====================
# Public API
# =====================
func get_active_banner() -> BannerBase:
	return _banners_by_id.get(active_banner_id)

func get_banner(id: String) -> BannerBase:
	return _banners_by_id.get(id)

func get_active_banners() -> Array[BannerBase]:
	return all_banners.filter(func(b): return b and b.active)

func get_all_banners() -> Array[BannerBase]:
	return all_banners.duplicate()

func set_active_banner(id: String) -> bool:
	if _banners_by_id.has(id) and _banners_by_id[id].active:
		active_banner_id = id
		return true
	return false

func cycle_next_banner() -> void:
	var active_list = get_active_banners()
	if active_list.size() < 2:
		return
	var current = get_active_banner()
	var current_idx = active_list.find(current)
	var next_idx = wrapi(current_idx + 1, 0, active_list.size())
	active_banner_id = active_list[next_idx].id