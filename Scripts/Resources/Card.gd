class_name Card;
extends Node;

func load_move(move : Move) -> void:
	$Icon.texture = move.icon;
	$Title.text = move.name;
	$Description.text = move.description;
