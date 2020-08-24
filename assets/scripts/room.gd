extends RigidBody2D

const GHOST = preload("res://assets/objects/enemies/Ghost.tscn");
const EMBENT = preload("res://assets/objects/enemies/Embent.tscn");
const TREASURE_CHEST = preload("res://assets/objects/Chest.tscn")
const GLARE = preload("res://assets/objects/Glare.tscn");

var size;
var room_types = [
	{
		# Good Treasure
		"area": { "start": 50, "end": INF },
		"size": [4, 6],
		"objects": [
			[TREASURE_CHEST, Vector2(8, 8)]
		]
	},
	{
		# Single enemy
		"area": { "start": -INF, "end": 175 },
		"size": [4, 8],
		"objects": [
			[GHOST, Vector2(8, 8)]
		]
	},
	{
		# Multiple enemies
		"area": { "start": -50, "end": INF },
		"size": [4, 8],
		"objects": [
			[GHOST, Vector2(8, 5)],
			[GHOST, Vector2(5, 9)],
			[GHOST, Vector2(11, 9)],
		]
	},
	{
		# Single enemy
		"area": { "start": 100, "end": INF },
		"size": [4, 8],
		"objects": [
			[EMBENT, Vector2(8, 8)]
		]
	}
]

func make(pos, extents):
	position = pos;
	size = extents;
	var shape = RectangleShape2D.new();
	shape.custom_solver_bias = 0.75
	shape.extents = size;
	$CollisionShape2D.shape = shape;

func populate():
	var possible_types = [];
	var tilemap = get_node("/root/World/Level");
	var level_extents = tilemap.get_used_rect();

	for type in room_types:
		var append = true;

		var min_area = (level_extents.position.x + type.area.start) * tilemap.cell_size.x;
		var max_area = (level_extents.end.x + type.area.end) * tilemap.cell_size.x;

		if (position.x < min_area) or (position.x > max_area):
			append = false;

		if append:
			possible_types.append(type);
	
	if (possible_types.size() == 0): return;

	var type = possible_types[randi() % possible_types.size()];

	for object in type.objects:
		var node = object[0].instance();
		node.position = position + object[1];
		get_node("/root/World/Objects").add_child(node);

func populate_glare():
	var node = GLARE.instance();
	node.position = position;
	get_node("/root/World/Objects").add_child(node);