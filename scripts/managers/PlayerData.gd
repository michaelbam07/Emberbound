# scripts/managers/PlayerData.gd
extends Node
class_name PlayerData

static var instance: PlayerData = null

# =====================
# Signals
# =====================
signal currency_changed(type: String, new_amount: int)
signal companion_added(companion: CompanionItem)
signal companion_removed(companion: CompanionItem)
signal weapon_added(weapon: WeaponItem)
signal weapon_removed(weapon: WeaponItem)
signal pity_updated(banner_id: String, pity: int)
signal level_up(new_level: int)
signal data_saved()
signal data_loaded()

# =====================
# Data
# =====================
var currencies: Dictionary = {
	"gold": 1000,
	"gems": 50,
	"tickets": 0,
	"dust": 0
}

var companions: Array[CompanionItem] = []
var weapons: Array[WeaponItem] = []

var pity_counters: Dictionary = {}  # banner_id → int

var player_level: int = 1
var experience: int = 0

var equipped_companion_id: String = ""
var equipped_weapon_id: String = ""

# =====================
# Constants
# =====================
const SAVE_PATH: String = "user://player_data.save"
const SAVE_VERSION: int = 2

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	if instance == null:
		instance = self
	else:
		queue_free()  # Prevent duplicates

# =====================
# Singleton Access
# =====================
static func get_instance() -> PlayerData:
	return instance

# =====================
# Currency
# =====================
func add_currency(type: String, amount: int) -> void:
	currencies[type] = currencies.get(type, 0) + amount
	currency_changed.emit(type, currencies[type])

func spend_currency(type: String, amount: int) -> bool:
	if currencies.get(type, 0) < amount:
		return false
	currencies[type] -= amount
	currency_changed.emit(type, currencies[type])
	return true

func get_currency(type: String) -> int:
	return currencies.get(type, 0)

# =====================
# Inventory
# =====================
func add_companion(companion: CompanionItem) -> void:
	companions.append(companion)
	companion_added.emit(companion)

func add_weapon(weapon: WeaponItem) -> void:
	weapons.append(weapon)
	weapon_added.emit(weapon)

func get_companions() -> Array[CompanionItem]:
	return companions.duplicate()

func get_weapons() -> Array[WeaponItem]:
	return weapons.duplicate()

# =====================
# Equipped Items
# =====================
func get_equipped_companion() -> CompanionItem:
	for c in companions:
		if c.id == equipped_companion_id:
			return c
	return null

func get_equipped_weapon() -> WeaponItem:
	for w in weapons:
		if w.id == equipped_weapon_id:
			return w
	return null

func equip_companion(id: String) -> void:
	if companions.any(func(c): return c.id == id):
		equipped_companion_id = id

func equip_weapon(id: String) -> void:
	if weapons.any(func(w): return w.id == id):
		equipped_weapon_id = id

# =====================
# Pity
# =====================
func get_pity_for_banner(banner_id: String) -> int:
	return pity_counters.get(banner_id, 0)

func update_pity_for_banner(banner_id: String, new_value: int) -> void:
	pity_counters[banner_id] = new_value
	pity_updated.emit(banner_id, new_value)

func increment_pity(banner_id: String) -> void:
	update_pity_for_banner(banner_id, get_pity_for_banner(banner_id) + 1)

func reset_pity(banner_id: String) -> void:
	update_pity_for_banner(banner_id, 0)

# =====================
# Experience & Leveling
# =====================
func add_experience(amount: int) -> void:
	experience += amount
	var old_level = player_level
	while experience >= required_exp_for_next_level():
		experience -= required_exp_for_next_level()
		player_level += 1
	if player_level > old_level:
		level_up.emit(player_level)

func required_exp_for_next_level() -> int:
	return 100 + (player_level - 1) * 50

# =====================
# Save / Load
# =====================
func save_data() -> void:
	var save_data = {
		"version": SAVE_VERSION,
		"currencies": currencies,
		"pity_counters": pity_counters,
		"player_level": player_level,
		"experience": experience,
		"equipped_companion_id": equipped_companion_id,
		"equipped_weapon_id": equipped_weapon_id,
		"companions": companions.map(func(c): return c.to_save_dict()),
		"weapons": weapons.map(func(w): return w.to_save_dict())
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "  ", false))
		file.close()
		data_saved.emit()
	else:
		push_error("PlayerData: Failed to save!")

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data_loaded.emit()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("PlayerData: Failed to load save file")
		return
	
	var content = file.get_as_text()
	file.close()
	
	var parse = JSON.new()
	if parse.parse(content) != OK:
		push_error("PlayerData: Corrupted save file")
		return
	
	var data = parse.data
	if data.get("version", 1) != SAVE_VERSION:
		push_warning("PlayerData: Save version mismatch — attempting load")
	
	currencies = data.get("currencies", currencies)
	pity_counters = data.get("pity_counters", {})
	player_level = data.get("player_level", 1)
	experience = data.get("experience", 0)
	equipped_companion_id = data.get("equipped_companion_id", "")
	equipped_weapon_id = data.get("equipped_weapon_id", "")
	
	# Load items
	companions.clear()
	for c_dict in data.get("companions", []):
		var c = CompanionItem.new()
		c.from_save_dict(c_dict)
		companions.append(c)
	
	weapons.clear()
	for w_dict in data.get("weapons", []):
		var w = WeaponItem.new()
		w.from_save_dict(w_dict)
		weapons.append(w)
	
	data_loaded.emit()

# =====================
# Debug
# =====================
func debug_give_everything() -> void:
	add_currency("gems", 9999)
	add_currency("dust", 9999)
	player_level = 50
	# Add all companions/weapons at max level, etc.