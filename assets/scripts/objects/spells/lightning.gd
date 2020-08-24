extends "res://assets/scripts/classes/spell.gd"

const LIGHTNING_STRIKE = preload("res://assets/objects/projectiles/LightningStrike.tscn")
var in_use = false;

func get_spell_data():
	return {
		"id": "lightning",
		"name": "Lightning",
		"mana_cost": 20,
		"icon": "res://assets/art/spells/icons/lightning.png"
	}

func action():
	if !in_use:
		var obj = LIGHTNING_STRIKE.instance();
		obj.position = Vector2(16, 0);
		get_parent().get_parent().add_child(obj);
		in_use = true;
		obj.get_node("Timer").connect("timeout", self, "recharge", [], CONNECT_ONESHOT);
	else:
		return true;

func recharge():
	in_use = false;


