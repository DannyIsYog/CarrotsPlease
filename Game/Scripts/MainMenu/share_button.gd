extends CharacterBody2D

@export var twitter_link_json = ""

var mouse_in = false
@onready var animation_player = $AnimationPlayer

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			var message = "Check it out! I'm just like " + get_parent().final_deer + "! "
			message += "Find out which Santa's Reindeer you are like at https://dannyisyog.itch.io/carrots-please"
			
			#var image_url = "https://github.com/DannyIsYog/CarrotsPlease/blob/main/Assets/Raindeers/" + get_parent().final_deer + ".png"
			
			var url = "https://twitter.com/intent/tweet?text=" + message
			
			var command = ""
			
			if OS.get_name() == "windows":
				command = "start "
			elif OS.get_name() == "osx ":
				command = "open"
			elif OS.get_name() == "x11":
				command = "xdg-open "
			command += url
			var process = OS.shell_open(command)
			
			if process == OK:
				print("Opened Twitter link")
			else:
				print("Failed to open Twitter link")

func get_image_link(reindeer_name):
	var file = FileAccess.open(twitter_link_json, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish[reindeer_name]

func mouse_entered():
	mouse_in = true
	animation_player.play("hover_up")

func mouse_exited():
	mouse_in = false
	animation_player.play("hover_down")
