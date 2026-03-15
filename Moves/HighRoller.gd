extends Move

func _init():
	super(
		"High Roller",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 1-12 * 0.5x attack
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = randi_range(1, 13) * 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
