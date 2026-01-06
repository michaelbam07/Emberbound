# scripts/data/CompanionDatabase.gd
extends Node
class_name CompanionDatabase

# Rarity enum for safety (no more magic strings!)
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC }

# Role enum
enum Role { 
	BRAWLER, SHARPSHOOTER, SUPPORT, TRICKSTER, 
	TANK, DEMOLITION, MOUNT, GOD 
}

# Fast lookup by ID
@onready var companions_by_id: Dictionary = {}


const COMPANIONS: Dictionary = {
	# --- COMMON (15) ---
	"rustys_rat": {
		"id": "rustys_rat", "name": "Rusty's Rat", "rarity": Rarity.COMMON, "role": Role.TRICKSTER,
		"sprite_key": "companion_rustys_rat",
		"base_stats": {"health": 30, "damage": 8, "attack_speed": 1.5, "move_speed": 120},
		"passive": {"name": "Scavenger", "description": "Occasionally finds extra Silver Rounds"},
		"active_ability": null,
		"personality": "Skittish but loyal",
		"relationships": []
	},
	"billy_the_beetle": {
		"id": "billy_the_beetle", "name": "Billy the Beetle", "rarity": Rarity.COMMON, "role": Role.BRAWLER,
		"sprite_key": "companion_billy_beetle",
		"base_stats": {"health": 45, "damage": 6, "attack_speed": 1.0, "move_speed": 80},
		"passive": {"name": "Hard Shell", "description": "Takes 10% less damage"},
		"active_ability": null,
		"personality": "Slow but determined",
		"relationships": []
	},
	# ... (all your others – I’ll assume you paste the full list here with these fixes)
	"dust_bunny": {
		"id": "dust_bunny", "name": "Dust Bunny", "rarity": "common", "role": "support",
		"spriteKey": "companion_dust_bunny", "baseStats": {"health": 25, "damage": 4, "attackSpeed": 0.8, "moveSpeed": 150},
		"passive": {"name": "Lucky Foot", "description": "+5% bonus loot drops"},
		"activeAbility": null, "personality": "Jumpy and excitable", "relationships": []
	},
	"sand_lizard": {
		"id": "sand_lizard", "name": "Sand Lizard", "rarity": "common", "role": "sharpshooter",
		"spriteKey": "companion_lizard", "baseStats": {"health": 30, "damage": 10, "attackSpeed": 1.1, "moveSpeed": 130},
		"passive": {"name": "Camouflage", "description": "Harder for enemies to target"},
		"activeAbility": null, "personality": "Lazy", "relationships": []
	},
	"pebble_pup": {
		"id": "pebble_pup", "name": "Pebble Pup", "rarity": "common", "role": "brawler",
		"spriteKey": "companion_pup", "baseStats": {"health": 40, "damage": 7, "attackSpeed": 1.2, "moveSpeed": 110},
		"passive": {"name": "Bark", "description": "Briefly distracts enemies"},
		"activeAbility": null, "personality": "Always hungry", "relationships": []
	},
	"scrap_spider": {
		"id": "scrap_spider", "name": "Scrap Spider", "rarity": "common", "role": "support",
		"spriteKey": "companion_spider", "baseStats": {"health": 20, "damage": 5, "attackSpeed": 1.6, "moveSpeed": 140},
		"passive": {"name": "Webbing", "description": "Slows enemies on hit by 5%"},
		"activeAbility": null, "personality": "Methodical", "relationships": []
	},
	"oil_slug": {
		"id": "oil_slug", "name": "Oil Slug", "rarity": "common", "role": "trickster",
		"spriteKey": "companion_slug", "baseStats": {"health": 50, "damage": 3, "attackSpeed": 0.5, "moveSpeed": 30},
		"passive": {"name": "Slick Trail", "description": "Leaves a trail that slows pursuit"},
		"activeAbility": null, "personality": "Gloomy", "relationships": []
	},
	"tin_toad": {
		"id": "tin_toad", "name": "Tin Toad", "rarity": "common", "role": "brawler",
		"spriteKey": "companion_toad", "baseStats": {"health": 35, "damage": 12, "attackSpeed": 0.6, "moveSpeed": 90},
		"passive": {"name": "Tongue Lash", "description": "Pulls small enemies closer"},
		"activeAbility": null, "personality": "Grumpy", "relationships": []
	},
	"wire_worm": {
		"id": "wire_worm", "name": "Wire Worm", "rarity": "common", "role": "support",
		"spriteKey": "companion_worm", "baseStats": {"health": 15, "damage": 2, "attackSpeed": 2.0, "moveSpeed": 100},
		"passive": {"name": "Conductive", "description": "+2% electric damage for player"},
		"activeAbility": null, "personality": "Energetic", "relationships": []
	},
	"bone_bird": {
		"id": "bone_bird", "name": "Bone Bird", "rarity": "common", "role": "sharpshooter",
		"spriteKey": "companion_bbird", "baseStats": {"health": 20, "damage": 14, "attackSpeed": 0.9, "moveSpeed": 160},
		"passive": {"name": "Hollow Bones", "description": "Faster flight speed"},
		"activeAbility": null, "personality": "Ominous", "relationships": []
	},
	"crate_crab": {
		"id": "crate_crab", "name": "Crate Crab", "rarity": "common", "role": "brawler",
		"spriteKey": "companion_crab", "baseStats": {"health": 50, "damage": 9, "attackSpeed": 0.8, "moveSpeed": 70},
		"passive": {"name": "Pinch", "description": "Small chance to stun"},
		"activeAbility": null, "personality": "Defensive", "relationships": []
	},
	"rusty_fly": {
		"id": "rusty_fly", "name": "Rusty Fly", "rarity": "common", "role": "support",
		"spriteKey": "companion_fly", "baseStats": {"health": 10, "damage": 1, "attackSpeed": 3.0, "moveSpeed": 220},
		"passive": {"name": "Buzz", "description": "Lowers enemy accuracy by 2%"},
		"activeAbility": null, "personality": "Annoying", "relationships": []
	},
	"dust_mite": {
		"id": "dust_mite", "name": "Dust Mite", "rarity": "common", "role": "support",
		"spriteKey": "companion_mite", "baseStats": {"health": 12, "damage": 4, "attackSpeed": 1.4, "moveSpeed": 130},
		"passive": {"name": "Allergy", "description": "Enemies sneeze, interrupting attacks"},
		"activeAbility": null, "personality": "Tiny", "relationships": []
	},
	"tumble_weed": {
		"id": "tumble_weed", "name": "Tumble", "rarity": "common", "role": "trickster",
		"spriteKey": "companion_tumble", "baseStats": {"health": 20, "damage": 5, "attackSpeed": 1.2, "moveSpeed": 200},
		"passive": {"name": "Wind-Blown", "description": "+10% Dodge chance"},
		"activeAbility": null, "personality": "Drifting", "relationships": []
	},
	"scrappy_shrew": {
		"id": "scrappy_shrew", "name": "Scrappy Shrew", "rarity": "common", "role": "brawler",
		"spriteKey": "companion_shrew", "baseStats": {"health": 35, "damage": 11, "attackSpeed": 1.3, "moveSpeed": 115},
		"passive": {"name": "Frenzy", "description": "Attacks faster as health drops"},
		"activeAbility": null, "personality": "Angry", "relationships": []
	},

	# --- UNCOMMON (12) ---
	"cactus_carl": {
		"id": "cactus_carl", "name": "Cactus Carl", "rarity": "uncommon", "role": "brawler",
		"spriteKey": "companion_cactus_carl", "baseStats": {"health": 60, "damage": 12, "attackSpeed": 0.7, "moveSpeed": 60},
		"passive": {"name": "Thorny Embrace", "description": "Enemies take 5 damage back"},
		"activeAbility": null, "personality": "Prickly exterior", "relationships": ["dust_bunny"]
	},
	"copper_crow": {
		"id": "copper_crow", "name": "Copper Crow", "rarity": "uncommon", "role": "sharpshooter",
		"spriteKey": "companion_copper_crow", "baseStats": {"health": 35, "damage": 15, "attackSpeed": 1.2, "moveSpeed": 180},
		"passive": {"name": "Eagle Eye", "description": "+8% player crit chance"},
		"activeAbility": null, "personality": "Silent", "relationships": ["iron_hawk"]
	},
	"flask_fox": {
		"id": "flask_fox", "name": "Flask Fox", "rarity": "uncommon", "role": "support",
		"spriteKey": "companion_fox", "baseStats": {"health": 40, "damage": 5, "attackSpeed": 1.0, "moveSpeed": 140},
		"passive": {"name": "Hydration", "description": "Potions are 15% stronger"},
		"activeAbility": null, "personality": "Wily", "relationships": []
	},
	"bullet_bat": {
		"id": "bullet_bat", "name": "Bullet Bat", "rarity": "uncommon", "role": "sharpshooter",
		"spriteKey": "companion_bat", "baseStats": {"health": 30, "damage": 18, "attackSpeed": 1.5, "moveSpeed": 190},
		"passive": {"name": "Sonar", "description": "Reveals hidden enemies"},
		"activeAbility": null, "personality": "Nocturnal", "relationships": []
	},
	"gear_goat": {
		"id": "gear_goat", "name": "Gear Goat", "rarity": "uncommon", "role": "brawler",
		"spriteKey": "companion_goat", "baseStats": {"health": 70, "damage": 14, "attackSpeed": 0.8, "moveSpeed": 100},
		"passive": {"name": "Ram", "description": "Knocks back enemies"},
		"activeAbility": null, "personality": "Stubborn", "relationships": []
	},
	"lantern_llama": {
		"id": "lantern_llama", "name": "Lantern Llama", "rarity": "uncommon", "role": "support",
		"spriteKey": "companion_llama", "baseStats": {"health": 55, "damage": 4, "attackSpeed": 0.7, "moveSpeed": 90},
		"passive": {"name": "Illumination", "description": "Increases vision in dark floors"},
		"activeAbility": null, "personality": "Gentle", "relationships": []
	},
	"wrench_weasel": {
		"id": "wrench_weasel", "name": "Wrench Weasel", "rarity": "uncommon", "role": "support",
		"spriteKey": "companion_weasel", "baseStats": {"health": 35, "damage": 8, "attackSpeed": 1.4, "moveSpeed": 160},
		"passive": {"name": "Repair", "description": "Slowly heals mechanical allies"},
		"activeAbility": null, "personality": "Busy", "relationships": []
	},
	"dust_devil_dog": {
		"id": "dust_devil_dog", "name": "Dust Devil", "rarity": "uncommon", "role": "trickster",
		"spriteKey": "companion_dddog", "baseStats": {"health": 45, "damage": 10, "attackSpeed": 1.3, "moveSpeed": 150},
		"passive": {"name": "Sand Kick", "description": "Reduces enemy vision"},
		"activeAbility": null, "personality": "Hyperactive", "relationships": []
	},
	"cider_cat": {
		"id": "cider_cat", "name": "Cider Cat", "rarity": "uncommon", "role": "support",
		"spriteKey": "companion_cat", "baseStats": {"health": 30, "damage": 6, "attackSpeed": 1.7, "moveSpeed": 160},
		"passive": {"name": "Purr", "description": "Reduces player ability cooldowns by 5%"},
		"activeAbility": null, "personality": "Aloof", "relationships": []
	},
	"panning_pig": {
		"id": "panning_pig", "name": "Panning Pig", "rarity": "uncommon", "role": "trickster",
		"spriteKey": "companion_pig", "baseStats": {"health": 50, "damage": 5, "attackSpeed": 0.9, "moveSpeed": 110},
		"passive": {"name": "Gold Sniffer", "description": "Points toward the nearest chest"},
		"activeAbility": null, "personality": "Greedy", "relationships": []
	},
	"sprocket_squirrel": {
		"id": "sprocket_squirrel", "name": "Sprocket Squirrel", "rarity": "uncommon", "role": "sharpshooter",
		"spriteKey": "companion_squirrel", "baseStats": {"health": 25, "damage": 12, "attackSpeed": 2.0, "moveSpeed": 180},
		"passive": {"name": "Nut Bolt", "description": "Throws bolts that have high crit chance"},
		"activeAbility": null, "personality": "Panic-prone", "relationships": []
	},
	"armor_armadillo": {
		"id": "armor_armadillo", "name": "Armor Armadillo", "rarity": "uncommon", "role": "brawler",
		"spriteKey": "companion_armadillo", "baseStats": {"health": 80, "damage": 10, "attackSpeed": 0.5, "moveSpeed": 70},
		"passive": {"name": "Rollout", "description": "High defense while moving"},
		"activeAbility": null, "personality": "Shy", "relationships": []
	},

	# --- RARE (10) ---
	"dynamite_dog": {
		"id": "dynamite_dog", "name": "Dynamite Dog", "rarity": "rare", "role": "demolition",
		"spriteKey": "companion_tnt_dog", "baseStats": {"health": 55, "damage": 25, "attackSpeed": 0.5, "moveSpeed": 110},
		"passive": {"name": "Blast Shield", "description": "Player takes 20% less blast damage"},
		"activeAbility": {"name": "Fetch!", "description": "Drops a bomb on nearest enemy", "cooldown": 20}, "personality": "Dangerous", "relationships": []
	},
	"steam_turtle": {
		"id": "steam_turtle", "name": "Steam Turtle", "rarity": "rare", "role": "tank",
		"spriteKey": "companion_turtle", "baseStats": {"health": 120, "damage": 8, "attackSpeed": 0.4, "moveSpeed": 40},
		"passive": {"name": "Pressure Valve", "description": "Slows nearby enemies"},
		"activeAbility": {"name": "Shell Spin", "description": "AOE damage", "cooldown": 15}, "personality": "Stoic", "relationships": []
	},
	"gold_gopher": {
		"id": "gold_gopher", "name": "Gold Gopher", "rarity": "rare", "role": "support",
		"spriteKey": "companion_gopher", "baseStats": {"health": 40, "damage": 5, "attackSpeed": 1.2, "moveSpeed": 130},
		"passive": {"name": "Deep Dig", "description": "Finds items in empty rooms"},
		"activeAbility": {"name": "Burrow", "description": "Becomes invulnerable", "cooldown": 10}, "personality": "Busy", "relationships": []
	},
	"medic_mule": {
		"id": "medic_mule", "name": "Medic Mule", "rarity": "rare", "role": "support",
		"spriteKey": "companion_mule", "baseStats": {"health": 100, "damage": 5, "attackSpeed": 0.6, "moveSpeed": 100},
		"passive": {"name": "Supply Pack", "description": "Holds 2 extra inventory slots"},
		"activeAbility": {"name": "First Aid", "description": "Heals player for 15HP", "cooldown": 45}, "personality": "Reliable", "relationships": []
	},
	"rocket_raccoon": {
		"id": "rocket_raccoon", "name": "Rocket Raccoon", "rarity": "rare", "role": "demolition",
		"spriteKey": "companion_raccoon", "baseStats": {"health": 45, "damage": 35, "attackSpeed": 0.4, "moveSpeed": 150},
		"passive": {"name": "Scavenged Tech", "description": "Explosives deal 10% more damage"},
		"activeAbility": {"name": "Rocket Jump", "description": "AOE blast at feet", "cooldown": 12}, "personality": "Cynical", "relationships": []
	},
	"shadow_lynx": {
		"id": "shadow_lynx", "name": "Shadow Lynx", "rarity": "rare", "role": "trickster",
		"spriteKey": "companion_lynx", "baseStats": {"health": 50, "damage": 22, "attackSpeed": 1.8, "moveSpeed": 170},
		"passive": {"name": "Night Hunter", "description": "Crit chance doubled in shadows"},
		"activeAbility": {"name": "Pounce", "description": "Leaps onto enemy", "cooldown": 8}, "personality": "Predatory", "relationships": []
	},
	"plasma_parrot": {
		"id": "plasma_parrot", "name": "Plasma Parrot", "rarity": "rare", "role": "sharpshooter",
		"spriteKey": "companion_parrot", "baseStats": {"health": 35, "damage": 20, "attackSpeed": 1.4, "moveSpeed": 190},
		"passive": {"name": "Mimic", "description": "Chance to repeat player's active skill"},
		"activeAbility": {"name": "Laser Chirp", "description": "Blinds target", "cooldown": 15}, "personality": "Talkative", "relationships": []
	},
	"anchor_ape": {
		"id": "anchor_ape", "name": "Anchor Ape", "rarity": "rare", "role": "brawler",
		"spriteKey": "companion_ape", "baseStats": {"health": 110, "damage": 25, "attackSpeed": 0.6, "moveSpeed": 85},
		"passive": {"name": "Heavyweight", "description": "Immune to knockback"},
		"activeAbility": {"name": "Ground Pound", "description": "Brief stun AOE", "cooldown": 20}, "personality": "Strong", "relationships": []
	},
	"valve_vulture": {
		"id": "valve_vulture", "name": "Valve Vulture", "rarity": "rare", "role": "support",
		"spriteKey": "companion_vulture", "baseStats": {"health": 40, "damage": 12, "attackSpeed": 1.0, "moveSpeed": 160},
		"passive": {"name": "Carrion Eater", "description": "Kills heal the vulture"},
		"activeAbility": {"name": "Screech", "description": "Lowers enemy defense", "cooldown": 25}, "personality": "Patient", "relationships": []
	},
	"magnet_mole": {
		"id": "magnet_mole", "name": "Magnet Mole", "rarity": "rare", "role": "support",
		"spriteKey": "companion_mole", "baseStats": {"health": 50, "damage": 4, "attackSpeed": 1.0, "moveSpeed": 60},
		"passive": {"name": "Magnetic Pull", "description": "Attracts coins from distance"},
		"activeAbility": {"name": "Pulse", "description": "Disarms nearby mechanicals", "cooldown": 30}, "personality": "Blind", "relationships": []
	},

	# --- EPIC (7) ---
	"clockwork_coyote": {
		"id": "clockwork_coyote", "name": "Clockwork Coyote", "rarity": "epic", "role": "trickster",
		"spriteKey": "companion_coyote", "baseStats": {"health": 70, "damage": 20, "attackSpeed": 1.8, "moveSpeed": 170},
		"passive": {"name": "Rewind", "description": "Chance to ignore fatal blow"},
		"activeAbility": {"name": "Time Howl", "description": "Freezes enemies", "cooldown": 30}, "personality": "Mischievous", "relationships": []
	},
	"iron_hawk": {
		"id": "iron_hawk", "name": "Iron Hawk", "rarity": "epic", "role": "sharpshooter",
		"spriteKey": "companion_hawk", "baseStats": {"health": 65, "damage": 30, "attackSpeed": 1.4, "moveSpeed": 200},
		"passive": {"name": "Marked", "description": "Enemies hit take 10% more damage"},
		"activeAbility": {"name": "Dive", "description": "High damage strike", "cooldown": 25}, "personality": "Noble", "relationships": ["copper_crow"]
	},
	"tesla_tiger": {
		"id": "tesla_tiger", "name": "Tesla Tiger", "rarity": "epic", "role": "brawler",
		"spriteKey": "companion_tiger", "baseStats": {"health": 90, "damage": 28, "attackSpeed": 1.5, "moveSpeed": 180},
		"passive": {"name": "Static Coat", "description": "Melee attackers get shocked"},
		"activeAbility": {"name": "Bolt", "description": "Dashes through enemies with lightning", "cooldown": 12}, "personality": "Fierce", "relationships": []
	},
	"plasma_panther": {
		"id": "plasma_panther", "name": "Plasma Panther", "rarity": "epic", "role": "trickster",
		"spriteKey": "companion_panther", "baseStats": {"health": 75, "damage": 35, "attackSpeed": 1.6, "moveSpeed": 200},
		"passive": {"name": "Phase", "description": "Short burst of invulnerability while moving"},
		"activeAbility": {"name": "Laser Swipe", "description": "AOE bleed damage", "cooldown": 10}, "personality": "Sleek", "relationships": []
	},
	"chrono_chameleon": {
		"id": "chrono_chameleon", "name": "Chrono Chameleon", "rarity": "epic", "role": "support",
		"spriteKey": "companion_cham", "baseStats": {"health": 50, "damage": 10, "attackSpeed": 1.1, "moveSpeed": 130},
		"passive": {"name": "Time Blur", "description": "Player moves 10% faster"},
		"activeAbility": {"name": "Slow-Mo", "description": "Slows time for 3s", "cooldown": 40}, "personality": "Patient", "relationships": []
	},
	"bio_bear": {
		"id": "bio_bear", "name": "Bio Bear", "rarity": "epic", "role": "tank",
		"spriteKey": "companion_bear", "baseStats": {"health": 200, "damage": 40, "attackSpeed": 0.5, "moveSpeed": 90},
		"passive": {"name": "Regen", "description": "Heals 1% health per second"},
		"activeAbility": {"name": "Roar", "description": "Enemies flee in terror", "cooldown": 20}, "personality": "Protective", "relationships": []
	},
	"radiant_ram": {
		"id": "radiant_ram", "name": "Radiant Ram", "rarity": "epic", "role": "brawler",
		"spriteKey": "companion_ram", "baseStats": {"health": 100, "damage": 25, "attackSpeed": 1.1, "moveSpeed": 120},
		"passive": {"name": "Holy Aura", "description": "Damages undead/demonic types automatically"},
		"activeAbility": {"name": "Charge", "description": "Stuns and burns targets", "cooldown": 15}, "personality": "Divine", "relationships": []
	},

	# --- LEGENDARY (4) ---
	"spirit_stallion": {
		"id": "spirit_stallion", "name": "Spirit Stallion", "rarity": "legendary", "role": "mount",
		"spriteKey": "companion_horse", "baseStats": {"health": 200, "damage": 15, "attackSpeed": 1.0, "moveSpeed": 250},
		"passive": {"name": "Ghost Run", "description": "Move through enemies"},
		"activeAbility": {"name": "Stampede", "description": "Mass knockback", "cooldown": 40}, "personality": "Ethereal", "relationships": []
	},
	"jade_dragon": {
		"id": "jade_dragon", "name": "Jade Dragon", "rarity": "legendary", "role": "sharpshooter",
		"spriteKey": "companion_dragon", "baseStats": {"health": 150, "damage": 45, "attackSpeed": 1.2, "moveSpeed": 180},
		"passive": {"name": "Fireball", "description": "Attacks explode"},
		"activeAbility": {"name": "Inferno", "description": "Screen-wide fire damage", "cooldown": 50}, "personality": "Wise", "relationships": []
	},
	"onyx_owl": {
		"id": "onyx_owl", "name": "Onyx Owl", "rarity": "legendary", "role": "support",
		"spriteKey": "companion_owl", "baseStats": {"health": 80, "damage": 25, "attackSpeed": 1.5, "moveSpeed": 200},
		"passive": {"name": "Omniscience", "description": "Shows map and item locations"},
		"activeAbility": {"name": "Nightmare", "description": "Enemies can't attack for 4s", "cooldown": 45}, "personality": "Ancient", "relationships": []
	},
	"mechanical_mammoth": {
		"id": "mechanical_mammoth", "name": "Mechanical Mammoth", "rarity": "legendary", "role": "tank",
		"spriteKey": "companion_mammoth", "baseStats": {"health": 400, "damage": 60, "attackSpeed": 0.3, "moveSpeed": 60},
		"passive": {"name": "Fortress", "description": "Player can hide behind for total cover"},
		"activeAbility": {"name": "Tusk Smash", "description": "Destroys all cover/walls nearby", "cooldown": 30}, "personality": "Gargantuan", "relationships": []
	},

	
	# --- MYTHIC (2) ---
	"solar_phoenix": {
		"id": "solar_phoenix", "name": "Solar Phoenix", "rarity": Rarity.MYTHIC, "role": Role.GOD,
		"sprite_key": "companion_phoenix",
		"base_stats": {"health": 300, "damage": 50, "attack_speed": 1.2, "move_speed": 220},
		"passive": {"name": "Rebirth", "description": "Resurrects player once per floor"},
		"active_ability": {"name": "Supernova", "description": "Screen clear projectiles", "cooldown": 60},
		"personality": "Radiant",
		"relationships": []
	},
	"void_manta": {
		"id": "void_manta", "name": "Void Manta", "rarity": Rarity.MYTHIC, "role": Role.TRICKSTER,
		"sprite_key": "companion_manta",
		"base_stats": {"health": 250, "damage": 40, "attack_speed": 1.5, "move_speed": 190},
		"passive": {"name": "Aura", "description": "Nearby enemies lose 50% accuracy"},
		"active_ability": {"name": "Rift", "description": "Deletes non-boss enemy", "cooldown": 45},
		"personality": "Alien",
		"relationships": []
	}
}

func _ready() -> void:
	_build_lookup()

func _build_lookup() -> void:
	for companion in COMPANIONS.values():
		if companion.has("id"):
			companions_by_id[companion["id"]] = companion

# =====================
# Public API
# =====================
func get_companion(id: String) -> Dictionary:
	return companions_by_id.get(id, {})

func get_all_companions() -> Array[Dictionary]:
	return COMPANIONS.values().duplicate()

func get_random_companion_of_rarity(rarity: Rarity) -> Dictionary:
	var matches: Array[Dictionary] = []
	for c in COMPANIONS.values():
		if c.rarity == rarity:
			matches.append(c)
	if matches.is_empty():
		return {}
	return matches[randi() % matches.size()]

func get_companions_in_pool(pool: Array[String]) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for id in pool:
		var c = get_companion(id)
		if not c.is_empty():
			result.append(c)
	return result