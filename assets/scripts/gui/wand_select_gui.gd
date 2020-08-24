extends Control

var is_open = false;

signal wand_selected(new_wand);

func open(old_wand, new_wand):
	get_tree().paused = true;
	is_open = true;
	get_node("/root/World/Objects/Player").focused = false;

	var old_wand_data = old_wand.get_wand_data();
	var new_wand_data = new_wand.get_wand_data();

	$Container/Wands/OldWand/Container/Slot/Wand.texture = load(old_wand_data.icon);
	$Container/Wands/OldWand/Container/WandName.text = old_wand_data.name;
	$Container/Wands/OldWand/Container/WandData.text = "Charging Speed: {charging_speed} mpt\nSpell Capacity: {spell_capacity}".format({"charging_speed": old_wand_data.recharge_speed, "spell_capacity": old_wand_data.spells});
	$Container/Wands/OldWand/Container/Spells/Slot1/Spell.texture = load(old_wand.get_spell(0).get_spell_data().icon);
	if old_wand_data.spells > 1: 
		$Container/Wands/OldWand/Container/Spells/Slot2/Spell.texture = load(old_wand.get_spell(1).get_spell_data().icon);
		$Container/Wands/OldWand/Container/Spells/Slot2.visible = true;
	else:
		$Container/Wands/OldWand/Container/Spells/Slot2.visible = false;
	
	$Container/Wands/NewWand/Container/Slot/Wand.texture = load(new_wand_data.icon);
	$Container/Wands/NewWand/Container/WandName.text = new_wand_data.name;
	$Container/Wands/NewWand/Container/WandData.text = "Charging Speed: {charging_speed} mpt\nSpell Capacity: {spell_capacity}".format({"charging_speed": new_wand_data.recharge_speed, "spell_capacity": new_wand_data.spells});
	$Container/Wands/NewWand/Container/Spells/Slot1/Spell.texture = load(new_wand.get_spell(0).get_spell_data().icon);
	if new_wand_data.spells > 1: 
		$Container/Wands/NewWand/Container/Spells/Slot2/Spell.texture = load(new_wand.get_spell(1).get_spell_data().icon);
		$Container/Wands/NewWand/Container/Spells/Slot2.visible = true;
	else:
		$Container/Wands/NewWand/Container/Spells/Slot2.visible = false;
	

func _process(_delta):
	visible = is_open;

func _on_wand_selected(wand):
	print(wand);
	get_tree().paused = false;
	is_open = false;
	get_node("/root/World/Objects/Player").focus_next = true;
	
	emit_signal("wand_selected", wand);
