extends Node

const ROOM = preload("res://assets/objects/Room.tscn");
const PLAYER = preload("res://assets/objects/Player.tscn");

export var room_count = 50;
export var min_room_size = 4;
export var max_room_size = 10;
export var hspread = 400;
export var cull = 0.5;

var path;
var start_room;
var end_room;
onready var Map = $Level;
onready var tile_size = Map.cell_size.x;

enum TILE_TYPE {
	GRASS1,
	GRASS2,
	FLOWER1,
	FLOWER2,
	TALL_GRASS,
	ROCKS
}

func _ready():
	randomize();
	make_rooms();

func vec3_from_vec2(vec2):
	return Vector3(vec2.x, vec2.y, 0);

func vec2_from_vec3(vec3):
	return Vector2(vec3.x, vec3.y);

func random_floor_tile():
	return (randi() % 5)

func make_rooms():
	for _i in range(room_count):
		var room = ROOM.instance();
		var pos = Vector2(rand_range(-hspread, hspread), 0);
		var size = Vector2((randi() % (max_room_size - min_room_size)) + min_room_size,
			(randi() % (max_room_size - min_room_size)) + min_room_size);
		room.make(pos, size * tile_size);
		$Rooms.add_child(room);
	
	# Wait for movement stop
	yield(get_tree().create_timer(1.1), "timeout");
	# Cull rooms
	var room_positions = [];
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free();
		else:
			room.mode = RigidBody2D.MODE_STATIC;
			room_positions.append(vec3_from_vec2(room.position));
	
	yield(get_tree(), "idle_frame")
	# Generate a MST connecting rooms
	path = find_mst(room_positions);

	# Make Player and Map
	make_map();
	make_player();
	populate_rooms();

func find_mst(nodes):
	# Prim's Algerithom
	var path = AStar.new();
	path.add_point(path.get_available_point_id(), nodes.pop_front());

	while nodes:
		var min_distance = INF;
		var min_pos = null;
		var pos = null;
		# Loop through points in path
		for pos1 in path.get_points():
			pos1 = path.get_point_position(pos1);
			# Loop through the remaining nodes
			for pos2 in nodes:
				# If the node is closer, make it the closest
				if pos1.distance_to(pos2) < min_distance:
					min_distance = pos1.distance_to(pos2);
					min_pos = pos2;
					pos = pos1;
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id();
		path.add_point(n, min_pos);
		path.connect_points(path.get_closest_point(pos), n);
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_pos);
	
	return path;

func make_map():
	# Create TileMap from generated rooms and path
	Map.clear();
	
	# Fill TileMap
	var full_rect = Rect2();
	
	for room in $Rooms.get_children():
		var rect = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents * 2);
		full_rect = full_rect.merge(rect);

	var top_left = Map.world_to_map(full_rect.position);
	var bottom_right = Map.world_to_map(full_rect.end);
	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			Map.set_cell(x, y, TILE_TYPE.ROCKS);

	# Carve Rooms and Paths
	var paths_carved = [];
	for room in $Rooms.get_children():
		# Carve Room
		var size = (room.size / tile_size).floor();
		var pos = Map.world_to_map(room.position);
		var ul = (room.position / tile_size).floor() - size;

		for x in range(2, size.x * 2 - 1):
			for y in range(2, size.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, random_floor_tile());
		
		# Carve Path
		var point = path.get_closest_point(vec3_from_vec2(room.position));

		for connection in path.get_point_connections(point):
			if not connection in paths_carved:
				var start = Map.world_to_map(vec2_from_vec3(path.get_point_position(point)));
				var end = Map.world_to_map(vec2_from_vec3(path.get_point_position(connection)));
				carve_path(start, end);
		
		paths_carved.append(point);

func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x);
	var y_diff = sign(pos2.y - pos1.y);
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2);
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2);

	# Choose x/y or y/x
	var xy = pos1;
	var yx = pos2;
	if (randi() % 2) > 0:
		xy = pos2;
		yx = pos1;
	
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, xy.y, random_floor_tile());
		Map.set_cell(x, xy.y + y_diff, random_floor_tile());

	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(yx.x, y, random_floor_tile());
		Map.set_cell(yx.x + x_diff, y, random_floor_tile());

func make_player():
	# Search for left-most room
	var min_x = INF;
	var min_room;
	for room in $Rooms.get_children():
		var x_pos = room.position.x - room.size.x;
		if (x_pos < min_x):
			min_x = x_pos;
			min_room = room;
	start_room = min_room;

	# Search for right-most room
	var max_x = -INF;
	var max_room;
	for room in $Rooms.get_children():
		var x_pos = room.position.x - room.size.x;
		if (x_pos > max_x):
			max_x = x_pos;
			max_room = room;
	end_room = max_room;

	# Disable Room Collision
	for room in $Rooms.get_children():
		room.get_node("CollisionShape2D").disabled = true;

	# Make and place player in scene
	var player_obj = PLAYER.instance();
	player_obj.position = start_room.position;
	$Objects.add_child(player_obj);
	player_obj.set_camera_limits();

func populate_rooms():
	for room in $Rooms.get_children():
		if (room != start_room and room != end_room):
			room.populate();
		elif (room == end_room):
			room.populate_glare();
