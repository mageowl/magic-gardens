extends "res://assets/scripts/classes/spell.gd"

const PROJECTILE = preload("res://assets/objects/projectiles/MagicShotProjectile.tscn");

func get_spell_data():
	return {
		"id": "magic_shot",
		"name": "Magic Shot",
		"mana_cost": 5,
		"icon": "res://assets/art/spells/icons/magic_shot.png"
	}

func action():
	var obj = PROJECTILE.instance();
	obj.position = get_parent().get_parent().get_global_transform().origin;
	obj.rotate(get_parent().get_parent().rotation);

	get_node("/root/World").add_child(obj);
