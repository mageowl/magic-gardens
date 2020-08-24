extends Enemy

func _process(_delta):
	if (health <= 0 or not player): return;

	var motion = (player.position - position).clamped(SPEED);
	move_and_slide(motion if not hit_player else motion * -100);

	var player_hit = false;
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider == player):
			player_hit = true;

	if (player_hit):
		player.damage(1);
		hit_player = true;
	else: hit_player = false;