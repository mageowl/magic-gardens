extends Node

var player_data = {
	"id": -1,
	"gold": 0,
	"wand": null,
};

func read_player_data():
	if (player_data.id != -1):
		print("New player data: " + str(player_data));
		get_node("/root/World/Objects/Player").pickup_coins(player_data.gold);
		get_node("/root/World/Objects/Player/Hand/Wand").free();
		get_node("/root/World/Objects/Player/Hand").add_child(player_data.wand);

func save_player_data():
	player_data.id += 1;
	player_data.gold = get_node("/root/World/Objects/Player").gold;
	player_data.wand = get_node("/root/World/Objects/Player/Hand/Wand").duplicate();

func clear_player_data():
	player_data.id = -1;
	player_data.gold = 0;
	player_data.wand = null;