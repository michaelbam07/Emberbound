extends Node
class_name BannerManager

var banners: Dictionary = {}
var active_banner_id: String = ""

func register_banner(banner: GachaBanner) -> void:
	banners[banner.id] = banner

func set_active_banner(banner_id: String) -> void:
	if banners.has(banner_id) and banners[banner_id].is_active():
		active_banner_id = banner_id
	else:
		push_error("Invalid or inactive banner: %s" % banner_id)

func get_active_banner() -> GachaBanner:
	return banners.get(active_banner_id, null)
