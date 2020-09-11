extends Spell

const PROJECTILE_CHARGE = preload("res://assets/objects/projectiles/FireballCharge.tscn");
const PROJECTILE_SHOOT = preload("res://assets/objects/projectiles/Fireball.tscn");
var charging = null;

func get_spell_data():
	return {
		"id": "fireball",
		"name": "Fireball",
		"mana_cost": 25,
		"icon": "res://assets/art/spells/icons/fireball.png"
	}

func action():
	if not charging:
		charging = PROJECTILE_CHARGE.instance();
		charging.position = Vector2(24, 0)
		get_parent().get_parent().add_child(charging);
	else:
		var projectile = PROJECTILE_SHOOT.instance();
		projectile.position = charging.global_position;
		projectile.rotation = charging.global_rotation;
		projectile.power = charging.power;

		get_node("/root/World").add_child(projectile);
		charging.queue_free();
		charging = null;

		return true;