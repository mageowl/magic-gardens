extends KinematicBody2D
class_name Player

const SPEED = 100;

var wand_data;
var recharging = false;
var health = 6;
var gold = 0;
var focused = true;
var focus_next = false;
var time = 0;

func _ready():
	get_node("/root/Global").read_player_data();

	update_wand();
	$Camera/CanvasLayer/PlayerGUI.set_health(6);


func damage(value):
	health -= value;
	$Camera/CanvasLayer/PlayerGUI.set_health(health);
	if (health <= 0):
		get_tree().change_scene("res://scenes/GameOver.tscn");

func _process(_delta):

	## Flip
	$Sprite.flip_h = get_global_mouse_position().x < get_position().x;

	## Input
	# Recharge
	if (Input.is_action_just_pressed("recharge")):
		recharging = true;
	
	if recharging: 
		if not $Hand/Wand.mana >= 100:
			$Hand/Wand.mana += wand_data.recharge_speed;
			$Camera/CanvasLayer/PlayerGUI.set_mana($Hand/Wand.mana);
		else: 
			recharging = false;
			$Hand/Wand.mana = 100;
			$Camera/CanvasLayer/PlayerGUI.set_mana($Hand/Wand.mana);

	# Cast
	if (Input.is_action_just_pressed("left_click") and not recharging and focused):
		var node = $Hand/Wand.get_spell(0);
		var cost = node.get_spell_data().mana_cost;
		if ($Hand/Wand.mana - cost >= 0):
			var canceled = node.action();
			if !canceled:
				$Hand/Wand.mana -= cost;
				$Camera/CanvasLayer/PlayerGUI.set_mana($Hand/Wand.mana);

	# Move
	var motion = Vector2();
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED;
		$Sprite.play("walk");
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED;
		$Sprite.play("walk");

	if Input.is_action_pressed("ui_down"):
		motion.y = SPEED;
		$Sprite.play("walk");
	elif Input.is_action_pressed("ui_up"):
		motion.y = -SPEED;
		$Sprite.play("walk");

	# Animation
	if (not motion):
		$Sprite.play("idle");
	
	## Move
	move_and_slide(motion);

	## Focus
	if focus_next:
		focused = true;
		focus_next = false;

func set_camera_limits():
	var tilemap = get_node("/root/World/Level");
	var map_limits = tilemap.get_used_rect();
	var map_cellsize = tilemap.cell_size;
	print(map_limits);
	$Camera.limit_left = map_limits.position.x * map_cellsize.x;
	$Camera.limit_right = map_limits.end.x * map_cellsize.x;
	$Camera.limit_top = map_limits.position.y * map_cellsize.y;
	$Camera.limit_bottom = map_limits.end.y * map_cellsize.y;

func pickup_coins(count):
	gold += count;
	$Camera/CanvasLayer/PlayerGUI.set_gold(gold);

func update_wand():
	wand_data = $Hand/Wand.get_wand_data();
	$Camera/CanvasLayer/PlayerGUI.update_wand_gui(wand_data);
