extends Move

func _init():
	super(
		"Coin Flip",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 1.2x or 0.5x attack to first enemy
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1.2 if randf() < 0.5 else 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
