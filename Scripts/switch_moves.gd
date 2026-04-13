extends Control

func _ready() -> void:
	movelist.add_move(movelist.random_move());
	movelist.add_move(movelist.random_move());
	
	# generate and display cards
	var card_scene = preload("res://Scenes/card.tscn");
	
	for i in gamemanager.move_list.size() - 1:
		var card = card_scene.instantiate();
		card.load_move(gamemanager.move_list[i]);
		$MoveInventory.add_child(card);
