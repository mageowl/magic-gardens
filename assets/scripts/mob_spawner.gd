extends Node2D

export(Array, String, FILE, "*.tscn") var mobs;
export(int) var mobLimit = 5;
onready var mob_count = mobLimit;
var on_screen = false;

func random(min_value, max_value):
	return ceil(rand_range(min_value, max_value));

func _ready():
	$Timer.wait_time = random(0, 5);

func _on_timer_finished():
	if not on_screen:
		$Timer.wait_time = random(10, 15);
		$Timer.start();
		return;
	mob_count -= 1;

	if (mob_count > 0):
		$Timer.wait_time = random(10, 15);
		$Timer.start();
	else:
		$Timer.stop();
		queue_free();
	
	var obj = load(mobs[random(0, mobs.size() - 1)]).instance();
	obj.position = get_global_transform().get_origin();
	get_node("/root/World/").add_child(obj);


func _on_screen_entered():
	on_screen = true;


func _on_screen_exited():
	on_screen = false;
