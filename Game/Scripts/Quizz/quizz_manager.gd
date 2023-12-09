extends Node2D

@onready var question_text = $QuestionText
@onready var science_text = $ScienceText
@onready var raindeerImage = $RaindeerImage
@export var buttons : Array[Node2D]

@export var json_file_path : String

var questions = []
var raindeer_likes = {}
var player_raindeer_correspondance = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	raindeer_likes = load_json()
	for names in raindeer_likes.keys():
		player_raindeer_correspondance[names] = 0
	
	for category in raindeer_likes["Donner"]:
		for item in raindeer_likes["Donner"][category]:
			questions.append([category, item])
	
	questions.shuffle()
	set_question()
	
func next_question():
	questions.remove_at(0)
	set_question()

func set_question():
	if(questions.size() == 0):
		end_quizz()
		return
	var category = questions[0][0]
	var item = questions[0][1]
	if category == "food":
		if item == "spicy" or item == "savory":
			question_text.text = "[center]Do you enjoy " + item + " foods?[/center]"
		else:
			question_text.text = "[center]Do you enjoy " + item + "?[/center]"
	elif category == "music":
		question_text.text = "[center]Do you enjoy " + item + " music?[/center]"
	elif category == "movies":
		question_text.text = "[center]Do you enjoy " + item + " movies?[/center]"
	elif category == "games":
		question_text.text = "[center]Do you enjoy " + item + " games?[/center]"

func end_quizz():
	for button in buttons:
		button.queue_free()
	print(player_raindeer_correspondance)
	var raindeer_name = findHighestKey(player_raindeer_correspondance)
	question_text.text = "[center]You are just like " + raindeer_name + "!!![/center]"
	science_text.text = "[center]Scientifically Proven![/center]"
	var path_to_image = "res://Assets/Raindeers/" + raindeer_name + ".png"
	
	raindeerImage.texture = load(path_to_image)
	
func like():
	answer_question("like")

func dislike():
	answer_question("dislike")

func neutral():
	answer_question("neutral")

func answer_question(answer):
	if(questions.size() == 0):
		return
	var category = questions[0][0]
	var item = questions[0][1]
	for raindeer in raindeer_likes.keys():
		if raindeer_likes[raindeer][category][item] == answer:
			player_raindeer_correspondance[raindeer] += 1
	next_question()

func findHighestKey(dictionary: Dictionary) -> String:
	var maxKey: String = ""
	var maxValue: int = -1

	for key in dictionary.keys():
		var value = dictionary[key]

		if value > maxValue:
			maxKey = key
			maxValue = value

	return maxKey

func load_json() -> Dictionary:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish["raindeers"]
