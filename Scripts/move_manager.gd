extends Node

var movelist: Array[Move] = [
	preload("res://Moves/BasicAttack.tres"),
	preload("res://Moves/Fireball.tres"),
	preload("res://Moves/MagicMissile.tres"),
	preload("res://Moves/Rest.tres"),
	preload("res://Moves/Slash.tres"),
	preload("res://Moves/Strike.tres")
]

func addCard(move: Move):
	if(!gamemanager.movelist.has(move)):
		gamemanager.movelist.append(move)

func removeCard(move: Move):
	if(gamemanager.movelist.has(move)):
		var value = gamemanager.movelist.find(move)
		gamemanager.movelist.remove_at(value)

func replaceCard(oldMove: Move, newMove: Move):
	if(gamemanager.movelist.has(oldMove)):
		var value = gamemanager.movelist.find(oldMove)
		gamemanager.movelist.remove_at(value)
		gamemanager.movelist.insert(value, newMove)

func chooseRandomMove():
	var chosenMove = movelist[randi_range(0,movelist.size()-1)]
	print(chosenMove.name)
	return chosenMove
