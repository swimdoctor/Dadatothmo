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
var player_attack = 10

var pending_enemy_data: Array[EnemyData] = []
var current_enemies: Array[Enemy]
var move_list: Array[Move]

# TESTING
func _ready() -> void:
	add_card_from_name(movelist.MoveName.STRIKE);
	add_card_from_name(movelist.MoveName.FIREBALL);

var current_map: GameMap = null
var map_scene := preload("res://Scenes/map.tscn")

#region Pause Menu
var pause_menu_scene: PackedScene = preload("res://Scenes/pause_menu.tscn")
var pause_instance: Control = null
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause_menu();
	if event.is_pressed():
		print("SDJHFKJSHDFKJ " + event.as_text())
		if(event.as_text().contains("Q") and current_enemies[0]):
			current_enemies[0].damage(100)
		if(event.as_text().contains("W")):
			player_health = max_player_health
		
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
	
	# Clear current list of enemies to avoid null references
	current_enemies = []
	
	get_tree().paused = false
	# attach the current map to gamemanager to save it
	# then turn it off
	detach_map()
	
	match newState:
		GameState.MainMenu:
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		GameState.Map:
			get_tree().change_scene_to_file("res://Scenes/map.tscn")
		GameState.Fighting:
			pending_enemy_data = [enemylist.random_enemy_data()]
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
	if(!move_list.has(move)):
		move_list.append(move)

func add_card_from_name(move_name : movelist.MoveName):
	var new_move = movelist.new_move(move_name)
	move_list.append(new_move)

func damage_player(damage: int) -> void:
	player_health = max(player_health - damage, 0)
	if(player_health <= 0):
		game_over()

func heal_player(heal: int) -> void:
	player_health = min(player_health + heal, max_player_health)

# reset game state
# most of these should be unnecessary when nodes get restructured
func reset() -> void:
	max_player_health = 100
	player_health = max_player_health
	
	# reset move list
	move_list = []
	
	add_card_from_name(movelist.MoveName.STRIKE);
	add_card_from_name(movelist.MoveName.REST);
	
	if current_map:
		current_map.queue_free()
	load_map()
	
func game_over() -> void:
	print("Game Over!")
	
	change_gamestate(GameState.MainMenu)

# --- Map Creation ---
func load_map() -> GameMap:
	if !is_instance_valid(current_map):
		current_map = map_scene.instantiate()
		current_map.createMap()
	else:
		print("Map valid")
		
	current_map.visible = true
	
	if current_map.get_parent():
		current_map.get_parent().remove_child(current_map)
	add_child(current_map)
	
	return current_map
	
func detach_map():
	if !is_instance_valid(current_map):
		return
	if current_map.get_parent():
		current_map.get_parent().remove_child(current_map)
		
	add_child(current_map)
	
	current_map.visible = false
	# reset enemies
	current_enemies = []
