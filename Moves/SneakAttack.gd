extends Move

func _init():
	super(
		"Sneak Attack",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 0.65x attack to lowest health enemy
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.65;
	var target = enemies[0];
	for enemy in enemies:
		if enemy.health < target.health:
			target = enemy;
	
	target.damage(damage * rhythm.attack);
