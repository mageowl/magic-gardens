extends Line2D
var ray = null;

func _process(_delta):
	update_ray();

func update_ray():
	var space_state = get_world_2d().direct_space_state;

	var mouse_pos = get_global_mouse_position();
	var player = get_parent().get_parent().get_parent();
	ray = space_state.intersect_ray(global_position, (global_position.direction_to(mouse_pos) * 320) + global_position, [player]);
	if ray:
		if get_point_count() == 1:
			add_point(to_local(ray.position));
		else:
			set_point_position(1, to_local(ray.position));

		if ray.collider.is_in_group("Enemy"):
			ray.collider.damage(1);
