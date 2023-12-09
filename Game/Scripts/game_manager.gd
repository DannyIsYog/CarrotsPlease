extends Node2D

class_name GameManager

@export_file("*.tscn") var mainMenuScenePath

@export_file("*.tscn") var mainGameScenePath

@export_file("*.tscn") var endInvestigationScenePath

@export_file("*.tscn") var quizzScenePath

@export_file("*.tscn") var creditsScenePath

@export_file("*.tscn") var startScenePath

var loadedScenePath

@onready var startingScene = $MainMenu
@onready var current_active_scene = $MainMenu 

var is_raindeer = false
var raindeer_name = ""

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

func loadMainGame(currentScene):
	loadedScenePath = mainGameScenePath
	var mainGameScene = load(mainGameScenePath).instantiate()
	current_active_scene = mainGameScene
	currentScene.queue_free()
	call_deferred("add_child", mainGameScene)

func loadQuizzGame(currentScene):
	loadedScenePath = quizzScenePath
	var quizzGameScene = load(quizzScenePath).instantiate()
	current_active_scene = quizzGameScene
	currentScene.queue_free()
	call_deferred("add_child", quizzGameScene)

func loadCredits(currentScene):
	loadedScenePath = creditsScenePath
	var creditsScene = load(creditsScenePath).instantiate()
	current_active_scene = creditsScene
	currentScene.queue_free()
	call_deferred("add_child", creditsScene)

func end_investigation(currentScene, is_raindeer):
	self.is_raindeer = is_raindeer
	loadedScenePath = endInvestigationScenePath
	var endInvestigationScene = load(endInvestigationScenePath).instantiate()
	current_active_scene = endInvestigationScene
	currentScene.queue_free()
	call_deferred("add_child", endInvestigationScene)
