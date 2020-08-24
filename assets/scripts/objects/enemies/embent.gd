extends Enemy

var attack_charge = 0;
const MAX_ATTACK_CHARGE = 200;

func damage(value):
	if ($Sprite.animation != "attack"): return;
	health -= value;
	if (health <= 0):
		$Sprite.play("death");
		$CollisionShape.queue_free();

func _process(_delta):
	if (health <= 0 or not player): return;

	var space_state = get_world_2d().direct_space_state;
	var ray = space_state.intersect_ray(position, player.position, [self]);

	if ray && ray.collider == player && $Sprite.animation != "attack":
		$Sprite.play("charge");
		attack_charge += 1;
		
		if (attack_charge >= MAX_ATTACK_CHARGE):
			$Sprite.play("attack");
			attack_charge = 0;
	elif $Sprite.animation != "attack":
		$Sprite.play("idle");
		attack_charge = 0;

func _on_animation_finished():
	if $Sprite.animation == "death":
		queue_free();
	elif $Sprite.animation == "attack":
		player.damage(1);
		$Sprite.play("idle");
