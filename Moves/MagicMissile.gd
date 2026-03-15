extends Move

func _init():
	super(
		"Magic Missile",
		load("res://Images/Test/IconRoughFire.png"),
		[Direction.UP, Direction.LEFT, Direction.RIGHT, Direction.UP]
	);

# deal 0.4x attack stat to all enemies
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.4;
	
	for enemy in enemies:
		enemy.damage(damage * rhythm.attack);
