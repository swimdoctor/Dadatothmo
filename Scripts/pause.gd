extends Control

# TODO: someone with a pad add input action for pausing

@onready var resume_button = $CanvasLayer/MainContainer/ResumeButton
@onready var main_menu_button = $CanvasLayer/DebugContainer/MainMenuButton
@onready var rhythm_button = $CanvasLayer/DebugContainer/RhythmButton
@onready var map_button = $CanvasLayer/DebugContainer/MapButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	rhythm_button.pressed.connect(_on_rhythm_pressed)
	map_button.pressed.connect(_on_map_pressed)

	# hide by default
	$CanvasLayer.visible = false

func toggle_pause():
	$CanvasLayer.visible = !$CanvasLayer.visible
	get_tree().paused = $CanvasLayer.visible

# Button Actions
func _on_resume_pressed():
	toggle_pause()

func _on_main_menu_pressed():
	gamemanager.change_gamestate(gamemanager.GameState.MainMenu)	

func _on_rhythm_pressed():
	gamemanager.change_gamestate(gamemanager.GameState.Fighting)
	
func _on_map_pressed():
	gamemanager.change_gamestate(gamemanager.GameState.Map)
