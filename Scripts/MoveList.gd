class_name MoveList
extends Resource

enum MoveName {
	STRIKE,
	FIREBALL,
	REST,
	MAGIC_MISSILE,
	DOUBLE_ATTACK,
	SIMPLE_DIE,
	COIN_FLIP,
	HIGH_ROLLER,
	ALL_IN,
	MONEYMAKER,
	SNEAK_ATTACK,
	SNIPE,
	DAYLIGHT_JOB,
	LAST_RESORT,
	HEAL,
	RESTORE
}

#func new_move(move : MoveName):
#	match move:
#		

# deal 0.5x attack stat to first enemy
func strike(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 1x attack stat to first enemy
func fireball(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# heal 20 health
func rest(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 20;
	
	gamemanager.heal_player(heal);

# deal 0.4x attack stat to all enemies
func magic_missile(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.4;
	
	for enemy in enemies:
		enemy.damage(damage * rhythm.attack);

# deal 0.4x attack to first enemy twice
func double_attack(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.4;
	var target = enemies[0];
	
	for i in 2:
		target.damage(damage * rhythm.attack);

# deal 1-4 * 0.4x attack
func simple_die(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = randi_range(1, 5) * 0.4;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 1.2x or 0.5x attack to first enemy
func coin_flip(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1.2 if randf() < 0.5 else 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 1-12 * 0.5x attack
func high_roller(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = randi_range(1, 13) * 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 0.5x attack plus 1.5x for each crit
func moneymaker(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.5;
	for i in 2:
		damage += 1.5 if randf() < 0.166666 else 0;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);
