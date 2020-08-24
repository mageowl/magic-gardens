extends Control

var is_open = false;

signal done();

func open(item):
	get_tree().paused = true;
	is_open = true;
	get_node("/root/World/Objects/Player").focused = false;

	$Box/Container/ItemName.text = item.name;
	$Box/Container/Slot/Item.texture = load(item.texture)

func _process(_delta):
	visible = is_open;

	if Input.is_action_pressed("left_click") and is_open:
		is_open = false;
		get_tree().paused = false;
		get_node("/root/World/Objects/Player").focus_next = true;
		emit_signal("done");
