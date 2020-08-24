extends Control

func update_wand_gui(wand_data):
	$WandGUI/Container/Label/Name.text = wand_data.name;
	$WandGUI/Container/Slot/Icon.texture = load(wand_data.icon);
	$WandGUI/Container/Label/ManaBar/TextureProgress.value = 100;
	$WandGUI/Container/Label/ManaBar/TextureProgress/Label.text = "100/100";

func set_mana(mana):
	$WandGUI/Container/Label/ManaBar/TextureProgress.value = mana;
	$WandGUI/Container/Label/ManaBar/TextureProgress/Label.text = str(mana) + "/100";

func set_health(health):
	$LeftGUI/HealthBar.value = health;

func set_gold(coins):
	$LeftGUI/Gold/NinePatchRect/Container/Label.text = str(coins);
