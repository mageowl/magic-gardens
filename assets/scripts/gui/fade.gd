extends ColorRect

signal done();

func fade_in():
	$AnimationPlayer.play("fade_in");

func _on_animation_finished(_anim):
	emit_signal("done")
