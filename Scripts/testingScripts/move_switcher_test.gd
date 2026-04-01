extends Control


func _ready() -> void:
	var movesTemp: Array[Move] = [movelist.new_move(movelist.MoveName.STRIKE), movelist.new_move(movelist.MoveName.FIREBALL), movelist.new_move(movelist.MoveName.REST)];
	
	gamemanager.move_list = movesTemp
	
	_print_list()

func _print_list():
	$CurrentMoves.text = "Current Moves:\n"
	
	for i in gamemanager.move_list:
		$CurrentMoves.text += i.name + "\n"
		print(i.name)

func _on_button_pressed() -> void:
	movelist.add_move(movelist.MoveName.STRIKE);
	_print_list()

func _on_button_2_pressed() -> void:
	movelist.add_move(movelist.MoveName.DOUBLE_ATTACK);
	_print_list()

func _on_button_3_pressed() -> void:
	movelist.remove_move(movelist.MoveName.STRIKE);
	_print_list()

func _on_button_4_pressed() -> void:
	movelist.remove_move(movelist.MoveName.DOUBLE_ATTACK);
	_print_list()

func _on_button_5_pressed() -> void:
	movelist.replace_move(movelist.MoveName.FIREBALL, movelist.MoveName.REST);
	_print_list()

func _on_button_6_pressed() -> void:
	movelist.replace_move(movelist.MoveName.REST, movelist.MoveName.FIREBALL);
	_print_list()


func _on_button_7_pressed() -> void:
	movelist.add_move(movelist.random_move());
	_print_list();
