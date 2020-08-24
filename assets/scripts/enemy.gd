extends KinematicBody2D
class_name Enemy

var health = 10;
var hit_player = false;
onready var player = get_node("/root/World/Objects/Player");

const SPEED = 10;

func damage(value):
	health -= value;
	if (health <= 0):
		$Sprite.play("death");
		$CollisionShape.queue_free();

func _process(_delta):
	if (health <= 0): return;

	var motion = (player.position - position).clamped(SPEED);
	move_and_slide(motion if not hit_player else motion * -100);

	var player_hit = false;
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider == player):
			player_hit = true;

	if (player_hit):
		player.damage(1);
		hit_player = true;
	else: hit_player = false;

func _on_animation_finished():
	if $Sprite.animation == "death":
		queue_free();
