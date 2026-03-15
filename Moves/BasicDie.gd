extends Move

func _init():
	super(
		"Basic Die",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 1-4 * 0.4x attack
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = randi_range(1, 5) * 0.4;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
