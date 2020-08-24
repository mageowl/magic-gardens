extends Control

var scene;

func _ready():
	for button in $Menu/Buttons.get_children():
		print(button.target_scene);
		button.connect("pressed", self, "_on_Button_pressed", [button.target_scene]);

func _on_Button_pressed(target_scene):
	scene = target_scene
	$Fade.visible = true;
	$Fade.fade_in();

func _on_Fade_done():
	get_tree().change_scene(scene);
