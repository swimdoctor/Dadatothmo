class_name Enemy
extends Area2D

@export var health: int # how many times the enemy can be hit
@export var tempo: int # speed of enemy encounter
@export var attack_pattern: Array[String] # a list of strings for the enemies attack pattern

func _ready() -> void:
	# connect signals for enter area2D
	connect("body_entered", Callable(self, "_on_body_entered"))
	
func _on_body_entered(body: Node):
	gamemanager.current_enemy = self
	
	gamemanager.change_gamestate(gamemanager.GameState.Fighting)
	
# _process (delta)
	# - fires attacks periodically based on tempo and attack pattern
# attack (attack_type: string)
	# - carries out the attack, sending events and modifying stats as required
