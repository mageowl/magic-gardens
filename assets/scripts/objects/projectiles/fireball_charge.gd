extends Node2D

const POWER_MAX = 30;
const CHARGE_SPEED = 0.02
var power = 0.02;

func _process(_delta):
	power += CHARGE_SPEED;

	$Sprite.scale = Vector2(power, power);
