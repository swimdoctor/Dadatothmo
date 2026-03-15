extends Move

func _init():
	super(
		"Double Attack",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.UP, Direction.LEFT, Direction.UP, Direction.RIGHT, Direction.DOWN]
	);

# deal 0.4x attack to first enemy twice
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.4;
	var target = enemies[0];
	
	for i in 2:
		target.damage(damage * rhythm.attack);
