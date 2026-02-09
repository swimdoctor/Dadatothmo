extends Node

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
