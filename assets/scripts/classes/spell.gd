extends Node
class_name Spell

func get_spell_data():
	return {
		"id": "base_spell",
		"name": "Spell",
		"mana_cost": 0,
		"icon": "res://assets/art/gui/discard_spell.png"
	}

func action():
	pass