extends Node2D
class_name Wand

var mana = 100;

func get_wand_data():
	return {
		"id": "base_wand",
		"name": "Wand"
	}

func get_spell(spell_id):
	return $Spells.get_children()[spell_id];

func _process(_delta):
	visible = not get_parent().get_parent().recharging;
	look_at(get_global_mouse_position());
