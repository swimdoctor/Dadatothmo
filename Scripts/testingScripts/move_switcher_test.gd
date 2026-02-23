extends Control


func _ready() -> void:
	var movesTemp: Array[Move] = [load("res://Moves/BasicAttack.tres"),load("res://Moves/Fireball.tres"),load("res://Moves/MagicMissile.tres")]
	
	gamemanager.movelist = movesTemp
	
	_print_list()

func _print_list():
	$CurrentMoves.text = "Current Moves:\n"
	
	for i in gamemanager.movelist:
		$CurrentMoves.text += i.name + "\n"
		print(i.name)

func _on_button_pressed() -> void:
	movemanager.addCard(load("res://Moves/Strike.tres"))
	_print_list()

func _on_button_2_pressed() -> void:
	movemanager.addCard(load("res://Moves/Slash.tres"))
	_print_list()

func _on_button_3_pressed() -> void:
	movemanager.removeCard(load("res://Moves/Strike.tres"))
	_print_list()

func _on_button_4_pressed() -> void:
	movemanager.removeCard(load("res://Moves/Slash.tres"))
	_print_list()

func _on_button_5_pressed() -> void:
	movemanager.replaceCard(load("res://Moves/Fireball.tres"), load("res://Moves/Rest.tres"))
	_print_list()

func _on_button_6_pressed() -> void:
	movemanager.replaceCard(load("res://Moves/Rest.tres"), load("res://Moves/Fireball.tres"))
	_print_list()


func _on_button_7_pressed() -> void:
	movemanager.chooseRandomMove()
