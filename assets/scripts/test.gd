extends Node2D

var btn_pressed = false;
onready var data = rand_ray_point(Vector2(160, 80), 5)

func rand_ray_point(ray_hit, margin):
	randomize();
	var box = Rect2(-margin, 0, margin * 2, position.distance_to(ray_hit));
	var point = Vector2(rand_range(box.position.x, box.position.x + box.size.x), rand_range(box.position.y, box.position.y + box.size.y));
	
	# return point.rotated(position.angle_to(ray_hit));
	# return box;
	return {"point":point, "box":box};

func _draw():
	draw_rect(data.box, Color.red);
	draw_line(Vector2(0, 0), data.point.rotated(deg2rad(rad2deg(position.angle_to_point(Vector2(160, 80))) + 90)) if btn_pressed else data.point, Color.blue if not btn_pressed else Color.yellow, 2);
	draw_circle(Vector2(0, 0), 1, Color.green);
	draw_circle(to_local(Vector2(160, 80)), 1, Color.yellow);

func _process(delta):
	update();
	if Input.is_action_just_pressed("ui_accept"):
		btn_pressed = not btn_pressed;
