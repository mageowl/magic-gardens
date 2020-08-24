extends Control

var is_open = false;

signal spell_selected(spell);

func open(wand):
	get_tree().paused = true;
	is_open = true;
	get_node("/root/World/Objects/Player").focused = false;

	var multiple_spells = wand.get_wand_data().spells > 1

	var spell1_data = wand.get_spell(0).get_spell_data();

	var spell2_data;
	if multiple_spells: spell2_data = wand.get_spell(1).get_spell_data();

	$Container/Spell1/Container/SpellName.text = spell1_data.name;
	$Container/Spell1/Container/Slot/Spell.texture = load(spell1_data.icon);

	if multiple_spells:
		$Container/Spell2.visible = true;
		$Container/Spell2/Container/SpellName.text = spell2_data.name;
		$Container/Spell2/Container/Slot/Spell.texture = load(spell2_data.icon);
	else:
		$Container/Spell2.visible = false;

func _process(_delta):
	visible = is_open;

func _on_spell_selected(spell):
	get_tree().paused = false;
	is_open = false;
	get_node("/root/World/Objects/Player").focus_next = true;

	emit_signal("spell_selected", spell);
