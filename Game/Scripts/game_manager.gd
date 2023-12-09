extends Node2D

class_name GameManager

@export_file("*.tscn") var mainMenuScenePath

@export_file("*.tscn") var mainGameScenePath

@export_file("*.tscn") var quizzScenePath

@export_file("*.tscn") var creditsScenePath

@export_file("*.tscn") var startScenePath

var loadedScenePath

@onready var startingScene = $MainMenu
@onready var current_active_scene = $MainMenu 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadMainMenu(currentScene):
	loadedScenePath = mainMenuScenePath
	var mainMenuScene = load(mainMenuScenePath).instantiate()
	current_active_scene = mainMenuScene
	currentScene.queue_free()
	call_deferred("add_child", mainMenuScene)
