class_name GameManager
extends Node

# Call in other scripts using: gamemanager

enum GameState
{
	MainMenu,
	Paused,
	Dungeon,
	Fighting,
	Upgrading,
	GameOver
}

# --- Game State and Global Variables ---
var state: GameState = GameState.MainMenu
var previous_state: GameState # set by change_gamestate()

# --- Pause Menu ---
var pause_menu_scene: PackedScene = preload("res://Scenes/pause_menu.tscn")
var pause_instance: Control = null
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause_menu()
		
func toggle_pause_menu() -> void:
	if not pause_instance:
		_load_pause_menu()
	
	pause_instance.toggle_pause()
		
func _load_pause_menu() -> void:
	var current_scene = get_tree().current_scene
	pause_instance = pause_menu_scene.instantiate() as Control
	current_scene.add_child(pause_instance)
	
# --- State Management ---
func change_gamestate(newState: GameState):
	previous_state = state
	state = newState

# --- Scene Management ---
func change_scene(newState: GameState) -> void:
	change_gamestate(newState)
	get_tree().paused = false
	match newState:
		GameState.Paused:
			print("paused")
		GameState.MainMenu:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
		GameState.Dungeon:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
		GameState.Fighting:
			get_tree().change_scene_to_file("res://Scenes/rhythm.tscn")
		GameState.Upgrading:
			print("upgrading")
		GameState.GameOver:
			print("game over")
		_:
			print("unknown GameState")

func game_over() -> void:
	print("Game Over!")
	change_scene(GameState.MainMenu)
