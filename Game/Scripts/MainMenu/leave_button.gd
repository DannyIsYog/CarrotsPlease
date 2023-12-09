extends CharacterBody2D

var mouse_in = false
@onready var animation_player = $AnimationPlayer

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			get_tree().quit()

func mouse_entered():
	mouse_in = true
	animation_player.play("hover_up")

func mouse_exited():
	mouse_in = false
	animation_player.play("hover_down")
