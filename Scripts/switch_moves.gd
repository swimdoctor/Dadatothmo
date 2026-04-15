extends Control

var new_card;
var selected_card_index;

func _ready() -> void:
	# TESTING
	movelist.add_move(movelist.random_move());
	movelist.add_move(movelist.random_move());
	
	var card_scene = preload("res://Scenes/card.tscn");
	
	# generate current inventory
	for i in gamemanager.move_list.size() - 1:
		var card = card_scene.instantiate();
		card.load_move(gamemanager.move_list[i]);
		$MoveInventory.add_child(card);
	
	# generate new move
	new_card = card_scene.instantiate();
	new_card.scale = $MoveInventory.scale;
	new_card.load_move(gamemanager.move_list[gamemanager.move_list.size() - 1]);
	add_child(new_card);
	
	# align new card
	selected_card_index = floor((gamemanager.move_list.size() - 1) / 2);
	call_deferred("move_card", selected_card_index);

func move_card(index : int) -> bool:
	if(index >= gamemanager.move_list.size() - 1):
		return false;
	
	var align_card = $MoveInventory.get_child(index);
	var align_position = align_card.global_position;
	align_position.y += 84 * new_card.scale.y;
	new_card.global_position = align_position;
	return true;

func _unhandled_input(event : InputEvent) -> void:
	# select move
	if(event.is_action_pressed("up")):
		movelist.remove_at(selected_card_index);
		return;
	
	# discard move
	if(event.is_action_pressed("down")):
		movelist.remove_at(gamemanager.move_list.size() - 1);
		return;
	
	# move card
	if(event.is_action_pressed("left")):
		selected_card_index = (selected_card_index - 1) % (gamemanager.move_list.size() - 1);
		move_card(selected_card_index);
	if(event.is_action_pressed("right")):
		selected_card_index = (selected_card_index + 1) % (gamemanager.move_list.size() - 1);
		move_card(selected_card_index);

	
