extends Area2D

const SPEED = 3;
var has_hit = false;

func _process(_delta):
	if not has_hit:
		position.x += cos(rotation) * SPEED;
		position.y += sin(rotation) * SPEED;
	elif not $HitParticles.emitting:
		queue_free();

func hit(body):
	if (body.is_in_group("Enemy")):
		body.damage(10);
	$HitParticles.emitting = true;
	$Sprite.visible = false;
	$CollisionShape2D.queue_free();
	has_hit = true;