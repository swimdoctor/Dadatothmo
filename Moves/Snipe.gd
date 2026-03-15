extends Move

func _init():
	super(
		"Snipe",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 0.5x attack and 1.5x attack to second enemy, or 1x attack if none
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage1 = 0.5;
	var target1 = enemies[0];
	
	if enemies.size() > 1:
		var damage2 = 1.5;
		var target2 = enemies[1];
		
		target2.damage(damage2 * rhythm.attack);
	else:
		damage1 = 1;
	
	target1.damage(damage1 * rhythm.attack);
