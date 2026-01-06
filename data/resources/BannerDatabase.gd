# scripts/managers/BannerDatabase.gd
extends Node

@export var banners: Array[BannerBase] = []

var _by_id: Dictionary = {}

func _ready() -> void:
	_load_all_banners()

func _load_all_banners() -> void:
	var dir = DirAccess.open("res://data/banners/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				var banner: BannerBase = load("res://data/banners/" + file)
				if banner:
					banners.append(banner)
					_by_id[banner.id] = banner
			file = dir.get_next()
	
	# Or manually drag your .tres files into the array in editor

func get_active_banners() -> Array[BannerBase]:
	var active = []
	for b in banners:
		if b.active:
			active.append(b)
	return active

func get_banner_by_id(id: String) -> BannerBase:
	return _by_id.get(id)