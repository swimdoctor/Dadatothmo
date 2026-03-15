extends Move

func _init():
	super(
		"Moneymaker",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 0.5x attack plus 1.5x for each crit
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.5;
	for i in 2:
		damage += 1.5 if randf() < 0.166666 else 0;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
