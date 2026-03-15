extends Move

func _init():
	super(
		"Daylight Job",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# deal 1x attack, 0.05x max health self damage if no kill
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1;
	var target = enemies[0];
	var self_damage = 0.05;
	
	target.damage(damage * rhythm.attack);
	if target.health > 0:
		gamemanager.damage_player(self_damage * gamemanager.max_player_health);
