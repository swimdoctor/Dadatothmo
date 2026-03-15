extends Move

func _init():
	super(
		"Strike",
		load("res://Images/Test/IconRoughSword.png"),
		[Direction.LEFT, Direction.UP, Direction.RIGHT]
	);

# im not even attempting to describe this move here just delete when we get literally any better option
func do_move(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1.5;
	var self_damage = 0.15;
	var target = enemies[0];
	for enemy in enemies:
		if enemy.health < target.health:
			target = enemy;
	if target.health < target.max_health * 0.5:
		damage *= 2;
		self_damage *= 2;
	
	target.damage(damage * rhythm.attack);
	if target.health > 0:
		gamemanager.damage_player(self_damage * gamemanager.max_player_health);
