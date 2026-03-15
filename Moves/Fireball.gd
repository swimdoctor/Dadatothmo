extends Move

func _init():
	super(
		"Fireball",
		load("res://Images/Test/IconRoughFire.png"),
		[Direction.LEFT, Direction.RIGHT, Direction.LEFT, Direction.RIGHT]
	);

# deal 1x attack stat to first enemy
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
