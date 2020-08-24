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

func _on_animation_finished():
	if $Sprite.animation == "death":
		queue_free();
