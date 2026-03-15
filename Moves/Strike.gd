extends Move

func _init():
	super(
		"Strike",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 0.5x attack stat to first enemy
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
