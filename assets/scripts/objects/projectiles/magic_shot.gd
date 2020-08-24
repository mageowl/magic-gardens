extends Area2D

const SPEED = 3;

func _process(_delta):
	position.x += cos(rotation) * SPEED;
	position.y += sin(rotation) * SPEED;

func hit(body):
	if (body.is_in_group("Enemy")):
		body.damage(10);
	queue_free();