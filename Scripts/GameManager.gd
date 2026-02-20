class_name GameManager
extends Node

# Call in other scripts using: gamemanager

enum GameState
{
	MainMenu,
	Map,
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
	match newState:
		GameState.MainMenu:
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		GameState.Map:
			get_tree().change_scene_to_file("res://Scenes/map.tscn")
		#GameState.Dungeon:
		#	get_tree().change_scene_to_file("res://Scenes/main.tscn")
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

func damage_player(damage: int) -> void:
	player_health = max(player_health - damage, 0);
	if(player_health <= 0):
		game_over();

# reset game state
# most of these should be unnecessary when nodes get restructured
func reset() -> void:
	max_player_health = 100;
	player_health = max_player_health;
	
	# reset move list
	movelist = [];
	#movelist.push_back(load("res://Moves/Strike.tres"));
	#movelist.push_back(load("res://Moves/Fireball.tres"));
	#movelist.push_back(load("res://Moves/Rest.tres"));
	
	# reset enemies
	current_enemies = [];

func game_over() -> void:
	print("Game Over!")
	reset();
	change_gamestate(GameState.GameOver);
