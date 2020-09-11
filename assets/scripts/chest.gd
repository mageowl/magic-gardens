extends Area2D

var wands = [preload("res://assets/objects/wands/CrystalStaff.tscn"), preload("res://assets/objects/wands/LightningRod.tscn"), preload("res://assets/objects/wands/Flamebreaker.tscn")];
var spells = [preload("res://assets/objects/spells/MagicShot.tscn"), preload("res://assets/objects/spells/Lightning.tscn"), preload("res://assets/objects/spells/Fireball.tscn")]

var loot_table = {
	"items": [
		{"type": "spell", "count": 1},
		{"type": "wand", "count": 1},
		{"type": "spell", "count": 1},
		{"type": "wand", "count": 1},
		{"type": "gold", "count": 20},
		{"type": "gold", "count": 20},
		{"type": "gold", "count": 20},
		{"type": "gold", "count": 30},
		{"type": "gold", "count": 30},
		{"type": "gold", "count": 100},
	]
}

func _on_player_entered(player):

	if not player is Player:
		return;

	var item = loot_table.items[randi() % loot_table.items.size()];
	var item_data = {
		"name": "",
		"texture": "res://assets/art/coin.png"
	};
	var obj;

	if item.type == "gold":
		item_data.name = "Gold X" + str(item.count);
		player.pickup_coins(item.count);
	elif item.type == "wand":
		obj = wands[randi() % wands.size()].instance();
		var wand_data = obj.get_wand_data();
		item_data.name = wand_data.name;
		item_data.texture = wand_data.icon;
	elif item.type == "spell":
		obj = spells[randi() % spells.size()].instance();
		var spell_data = obj.get_spell_data();
		item_data.name = spell_data.name;
		item_data.texture = spell_data.icon;

	get_node("/root/World/UI/ItemCollectGUI").open(item_data);
	get_node("/root/World/UI/ItemCollectGUI").connect("done", self, "_on_item_gui_close", [player, item.type, obj], CONNECT_ONESHOT);

func _on_item_gui_close(player, item_type, obj):
	if item_type == "wand":
		get_node("/root/World/UI/WandSelectGUI").open(player.get_node("Hand/Wand"), obj);
		get_node("/root/World/UI/WandSelectGUI").connect("wand_selected", self, "_on_wand_selected", [player, obj], CONNECT_ONESHOT);
	elif item_type == "spell":
		get_node("/root/World/UI/SpellSelectGUI").open(player.get_node("Hand/Wand"));
		get_node("/root/World/UI/SpellSelectGUI").connect("spell_selected", self, "_on_spell_selected", [player, obj], CONNECT_ONESHOT);
	else:
		queue_free();

func _on_spell_selected(spell, player, obj):
	var wand = player.get_node("Hand/Wand");
	var spells = wand.get_node("Spells");

	if spell == 0:
		wand.get_spell(0).queue_free();
		spells.add_child(obj);
		spells.move_child(obj, 0);
	elif spell == 1:
		wand.get_spell(1).queue_free();
		spells.add_child(obj);
	else:
		obj.queue_free();

	queue_free();

func _on_wand_selected(new_wand, player, obj):
	if new_wand == 1:
		player.get_node("Hand/Wand").free();
		player.get_node("Hand").add_child(obj);
		player.update_wand();
	elif new_wand == 0:
		obj.queue_free();
	
	queue_free();