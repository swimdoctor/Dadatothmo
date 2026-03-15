extends Move

func _init():
	super(
		"Heal",
		load("res://Images/Test/IconRoughHealth.png"),
		[Direction.LEFT, Direction.UP, Direction.UP, Direction.UP, Direction.RIGHT]
	);

# heal 0.1x max health
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 0.1;
	
	recover(heal * gamemanager.max_player_health);
