class_name GameManager
extends Node

# Call in other scripts using: gamemanager

enum GameState
{
	MainMenu,
	Map,
	Dungeon,
	Fighting,
	Upgrading,
	GameOver
}

# --- Game State and Global Variables ---
var _state: GameState = GameState.MainMenu

var player_health: int = 100
var max_player_health: int = 100

var current_enemies: Array[Enemy]
var movelist: Array[Move]

var current_map: GameMap = null
var map_scene := preload("res://Scenes/map.tscn")

#region Pause Menu
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
	
#endregion

# --- Game Management ---
func change_gamestate(newState: GameState):
	"""
	Changes the gamestate and performs all associated actions that go along
	with editing the gamestate such as changing scenes and setting state variables.
	"""
	_state = newState
	
	# change scene
	_change_scene(newState)

func _change_scene(newState: GameState) -> void:
	"""
	Don't use outside of GameManager. Instead use change_gamestate.
	Changes the current scene to a new one based on the GameState.
	"""
	get_tree().paused = false
	# attach the current map to gamemanager to save it
	# then turn it off
	detach_map()
	
	match newState:
		GameState.MainMenu:
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		GameState.Map:
			get_tree().change_scene_to_file("res://Scenes/map.tscn")
		GameState.Dungeon:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
		GameState.Fighting:
			get_tree().change_scene_to_file("res://Scenes/rhythm_visual.tscn")
		GameState.Upgrading:
			get_tree().change_scene_to_file("res://Scenes/upgrades.tscn")
		GameState.GameOver:
			get_tree().change_scene_to_file("res://Scenes/lose.tscn")
			print("game over")
		_:
			print("unknown GameState")

func remove_enemy(enemy):
	current_enemies.remove_at(current_enemies.find(enemy))
	
	if(current_enemies.size() == 0):
		change_gamestate(GameState.Upgrading)
		
func add_card_to_hand(move: Move):
	if(!movelist.has(move)):
		movelist.append(move)
	
func game_over() -> void:
	print("Game Over!")
	change_gamestate(GameState.MainMenu)

# --- Map Creation ---
func load_map() -> GameMap:
	if !is_instance_valid(current_map):
		current_map = map_scene.instantiate()
		current_map.createMap()
		
	current_map.visible = true
	return current_map
	
func detach_map():
	if !is_instance_valid(current_map):
		return
	if current_map.get_parent():
		current_map.get_parent().remove_child(current_map)
		
	add_child(current_map)
	
	current_map.visible = false
