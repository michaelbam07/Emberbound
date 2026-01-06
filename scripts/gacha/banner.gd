extends Resource
class_name GachaBanner

@export var id: String
@export var name: String
@export var description: String

@export var banner_type: String # "weapon" | "companion"
@export var featured_items: Array[String] = [] # IDs
@export var rate_up_multiplier: float = 2.0

@export var start_time: int = 0 # unix
@export var end_time: int = 0   # unix

func is_active() -> bool:
	var now := Time.get_unix_time_from_system()
	return now >= start_time and now <= end_time
