extends Wand

func get_wand_data():
	return {
		"id": "flamebreaker",
		"name": "Flamebreaker",
		"spells": 2,
		"icon": "res://assets/art/wands/item/flamebreaker.png",
		"recharge_speed": 4
	};

func _process(delta):
	$Sprite.flip_v = get_global_mouse_position().x < global_position.x;