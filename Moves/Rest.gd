extends Move

func _init():
	super(
		"Rest",
		load("res://Images/Test/IconRoughHealth.png"),
		[Direction.LEFT, Direction.UP, Direction.UP, Direction.UP, Direction.RIGHT]
	);

# heal 20 health
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 20;
	
	recover(heal);
