extends RigidBody2D

const ENEMY = preload("res://assets/objects/MobSpawner.tscn");
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
			[ENEMY, Vector2(8, 8)]
		]
	},
	{
		# Empty
		"area": { "start": -INF, "end": INF },
		"size": [-INF, INF],
		"objects": [
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
	
	var type = possible_types[randi() % possible_types.size()];

	for object in type.objects:
		var node = object[0].instance();
		node.position = position + object[1];
		get_node("/root/World/Objects").add_child(node);

func populate_glare():
	var node = GLARE.instance();
	node.position = position;
	get_node("/root/World/Objects").add_child(node);