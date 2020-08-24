extends Button

func _pressed():
	get_node("/root/Global").clear_player_data();
	get_tree().change_scene("res://scenes/World.tscn");