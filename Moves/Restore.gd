extends Move

func _init():
	super(
		"Restore",
		load("res://Images/Test/IconRoughHealth.png"),
		[Direction.LEFT, Direction.UP, Direction.UP, Direction.UP, Direction.RIGHT]
	);

# heal 0.2x missing health
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 0.2;
	
	recover(heal * gamemanager.max_player_health - gamemanager.player_health);
