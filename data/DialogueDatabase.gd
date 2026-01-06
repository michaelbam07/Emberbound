# scripts/data/DialogueDatabase.gd
extends Node
class_name DialogueDatabase

# =====================
# Emberbound - Dialogue Database
# Typed, fast lookup, random seed safe, expandable
# =====================

# Fast lookup: trigger_id → Array[DialogueLine]
@onready var _dialogue_by_trigger: Dictionary = DIALOGUE.duplicate()

# Optional: Define a simple struct-like class for clarity (Godot 4 supports inner classes)
class DialogueLine extends RefCounted:
	var speaker: String = ""
	var text: String = ""

# Master dialogue data – cleaned up with consistent keys
const DIALOGUE: Dictionary = {
	# --- Campfire / Idle Banter ---
	"campfire_idle": [
		{"speaker": "ASH-9", "text": "You ever notice the fire hums louder when no one's talking?"},
		{"speaker": "VIREX", "text": "Thermal oscillation. Or ghosts. One of the two."},
		{"speaker": "ASH-9", "text": "I miss the smell of rain. Real rain, not that acid mist from the wastes."},
		{"speaker": "VIREX", "text": "Rain is just liquid entropy. Keep your circuits dry, Ash."},
		{"speaker": "ASH-9", "text": "If we don't make it back, tell them I died doing something cool."},
		{"speaker": "VIREX", "text": "I'll tell them you tripped over a pebble. It's more statistically likely."},
		{"speaker": "ASH-9", "text": "Staring into the embers makes me think about the Old World."},
		{"speaker": "VIREX", "text": "The Old World is a data fragment. Focus on the next sector."},
		{"speaker": "ASH-9", "text": "Is it just me, or does the sand taste... metallic today?"},
		{"speaker": "VIREX", "text": "Stop eating the sand, Ash."}
	],

	# --- Loot & Gacha Triggers ---
	"after_pull_common": [
		{"speaker": "ASH-9", "text": "Another piece of scrap for the pile."},
		{"speaker": "VIREX", "text": "Efficiency is found in the mundane."},
		{"speaker": "ASH-9", "text": "Well, it's better than throwing rocks."}
	],
	"after_pull_rare": [
		{"speaker": "ASH-9", "text": "Now we're talking. This has some weight to it."},
		{"speaker": "VIREX", "text": "Weapon specs are within the top 15th percentile. Acceptable."},
		{"speaker": "ASH-9", "text": "Finally, something that doesn't rattle when I shake it."}
	],
	"after_pull_epic": [
		{"speaker": "ASH-9", "text": "Whoa. This one's humming with energy."},
		{"speaker": "VIREX", "text": "Power output exceeds expected parameters by 180%. Proceed with caution."}
	],
	"after_pull_legendary": [
		{"speaker": "ASH-9", "text": "Huh. Guess fate finally blinked."},
		{"speaker": "VIREX", "text": "Anomaly detected. This power signature shouldn't exist here."},
		{"speaker": "ASH-9", "text": "Keep your voice down, Virex. Everyone's gonna want to steal this."}
	],
	"after_pull_mythic": [
		{"speaker": "VIREX", "text": "Calculation error. Probability was 0.001%. How?"},
		{"speaker": "ASH-9", "text": "I can feel the air vibrating... This thing is a monster."},
		{"speaker": "VIREX", "text": "User, I suggest immediate synchronization. This is... divine."}
	],

	# --- Combat & Danger ---
	"entering_boss_room": [
		{"speaker": "ASH-9", "text": "Big, ugly, and stands between us and the payday. Let's go."},
		{"speaker": "VIREX", "text": "Threat levels are spiking. Optimizing combat subroutines."},
		{"speaker": "ASH-9", "text": "If I die, Virex gets my collection of pre-war spoons."},
		{"speaker": "VIREX", "text": "I do not want the spoons, Ash."}
	],
	"low_health": [
		{"speaker": "ASH-9", "text": "Seeing double... and both of them look mad."},
		{"speaker": "VIREX", "text": "Structural integrity at 15%. Retreat is logical."},
		{"speaker": "ASH-9", "text": "Just a scratch. A very deep, bleeding scratch."},
		{"speaker": "VIREX", "text": "Vital signs are becoming... rhythmic. Not in a good way."}
	],

	# --- Exploration ---
	"empty_room": [
		{"speaker": "ASH-9", "text": "Dust and echoes. My favorite."},
		{"speaker": "VIREX", "text": "Scanning... nothing but silicon and disappointment."}
	],
	"found_secret": [
		{"speaker": "VIREX", "text": "Structural anomaly detected. A hidden compartment."},
		{"speaker": "ASH-9", "text": "Nice eye, Virex! Let's see what they tried to hide."}
	],

	# --- Character Quirks ---
	"virex_glitch": [
		{"speaker": "VIREX", "text": "E-e-error. Logic loop encountered. Does a machine dream of... sheep? No, that's ridiculous."},
		{"speaker": "ASH-9", "text": "You okay there, chrome-dome? Your eye is twitching."}
	],
	"ash_humming": [
		{"speaker": "ASH-9", "text": "(Hums a faint, distorted tune from the Old World)"},
		{"speaker": "VIREX", "text": "Your pitch is 440Hz off. It is causing my processors to itch."}
	]
}

# =====================
# Public API
# =====================

func get_random_line(trigger_id: String) -> Dictionary:
	var lines: Array = _dialogue_by_trigger.get(trigger_id, [])
	if lines.is_empty():
		push_warning("No dialogue found for trigger: ", trigger_id)
		return {"speaker": "???", "text": "..."}
	return lines[randi() % lines.size()]

func get_full_conversation(trigger_id: String) -> Array[Dictionary]:
	return _dialogue_by_trigger.get(trigger_id, []).duplicate()

func has_trigger(trigger_id: String) -> bool:
	return _dialogue_by_trigger.has(trigger_id)

# Bonus: Play a full sequence with delay (use in UI or narrator)
signal dialogue_line_played(line: Dictionary)

func play_conversation(trigger_id: String, delay_between_lines: float = 3.0) -> void:
	var lines: Array[Dictionary] = get_full_conversation(trigger_id)
	for line in lines:
		dialogue_line_played.emit(line)
		if delay_between_lines > 0:
			await get_tree().create_timer(delay_between_lines).timeout