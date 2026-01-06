# tools/BannerImporter.gd (add @tool so it runs in editor)
@tool
extends EditorScript

func _run() -> void:
	var loader = BannerLoader.new()
	loader.banner_json_path = "res://data/banner.json"
	loader.load_banners()
	
	var dir = DirAccess.open("res://data/banners/")
	if not dir:
		dir.make_dir_recursive("res://data/banners/")
	
	for banner_id in loader.banners.keys():
		var data = loader.banners[banner_id]
		var resource = BannerBase.new()
		
		resource.id = data.get("id", banner_id)
		resource.name = data.get("name", "Unknown Banner")
		resource.active = data.get("active", true)
		resource.rarity_rates = data.get("rarity_rates", {})
		resource.hard_pity = data.get("pity", {}).duplicate()
		resource.soft_pity_start = data.get("pity", {}).duplicate()
		resource.soft_pity_bonus = data.get("pity", {}).duplicate()
		resource.featured_units = data.get("featured", {})
		# Add more mappings as needed
		
		var path = "res://data/banners/%s.tres" % banner_id
		ResourceSaver.save(resource, path)
		print("Saved: ", path)