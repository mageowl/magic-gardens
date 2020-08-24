extends Area2D

func _ready():
	print("Glare loaded.")

func _on_player_entered(_player):
	print("Trasporting to next level...");
	get_node("/root/Global").save_player_data();
	get_tree().reload_current_scene();
