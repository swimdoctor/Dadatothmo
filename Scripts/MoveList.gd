class_name MoveList
extends Node

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

func new_move(move : MoveName):
	var name : String;
	var path : String;
	var pattern : Array[Move.Direction];
	var method : String;
	
	match move:
		MoveName.STRIKE: 
			name = "Strike";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.RIGHT];
			method = "strike";
		MoveName.FIREBALL:
			name = "Fireball";
			path = "res://Images/Test/IconRoughFire.png";
			pattern = [Move.Direction.LEFT, Move.Direction.RIGHT, Move.Direction.LEFT, Move.Direction.RIGHT];
			method = "fireball";
		MoveName.REST:
			name = "Rest";
			path = "res://Images/Test/IconRoughHealth.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.UP, Move.Direction.UP, Move.Direction.RIGHT];
			method = "rest";
		MoveName.MAGIC_MISSILE:
			name = "Magic Missile";
			path = "res://Images/Test/IconRoughFire.png"
			pattern = [Move.Direction.UP, Move.Direction.LEFT, Move.Direction.RIGHT, Move.Direction.UP];
			method = "magic_missile";
		MoveName.DOUBLE_ATTACK:
			name = "Double Attack";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.LEFT, Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.DOWN];
			method = "double_attack";
		MoveName.SIMPLE_DIE:
			name = "Simple Die";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.RIGHT];
			method = "simple_die";
		MoveName.COIN_FLIP:
			name = "Coin Flip";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.DOWN, Move.Direction.UP];
			method = "coin_flip";
		MoveName.HIGH_ROLLER:
			name = "High Roller";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.DOWN, Move.Direction.RIGHT];
			method = "high_roller";
		MoveName.ALL_IN:
			name = "All In";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.RIGHT, Move.Direction.UP, Move.Direction.LEFT, Move.Direction.DOWN];
			method = "all_in";
		MoveName.MONEYMAKER:
			name = "Moneymaker";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.DOWN, Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.LEFT, Move.Direction.UP];
			method = "moneymaker";
		MoveName.SNEAK_ATTACK:
			name = "Sneak Attack";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.LEFT];
			method = "sneak_attack";
		MoveName.SNIPE:
			name = "Snipe";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.DOWN];
			method = "snipe";
		MoveName.DAYLIGHT_JOB:
			name = "Daylight Job";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.DOWN];
			method = "daylight_job";
		MoveName.LAST_RESORT:
			name = "Last Resort";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.DOWN, Move.Direction.LEFT, Move.Direction.LEFT, Move.Direction.RIGHT, Move.Direction.RIGHT];
			method = "last_resort";
		MoveName.HEAL:
			name = "Heal";
			path = "res://Images/Test/IconRoughHealth.png";
			pattern = [Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.DOWN, Move.Direction.LEFT, Move.Direction.UP];
			method = "heal";
		MoveName.RESTORE:
			name = "Restore";
			path = "res://Images/Test/IconRoughHealth.png";
			pattern = [Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.LEFT, Move.Direction.UP];
			method = "restore";
	
	return Move.new(name, load(path), pattern, Callable(self, method));

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

# deal 0.5x attack on crit or 2.5x on crit
func all_in(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 2.5 if randf() < 0.166666 else 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 0.5x attack plus 1.5x for each crit
func moneymaker(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.5;
	for i in 2:
		damage += 1.5 if randf() < 0.166666 else 0;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 0.65x attack to lowest health enemy
func sneak_attack(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 0.65;
	var target = enemies[0];
	for enemy in enemies:
		if enemy.health < target.health:
			target = enemy;
	
	target.damage(damage * rhythm.attack);

# deal 0.5x attack and 1.5x attack to second enemy, or 1x attack if none
func snipe(enemies : Array[Enemy], rhythm : Rhythm):
	var damage1 = 0.5;
	var target1 = enemies[0];
	
	if enemies.size() > 1:
		var damage2 = 1.5;
		var target2 = enemies[1];
		
		target2.damage(damage2 * rhythm.attack);
	else:
		damage1 = 1;
	
	target1.damage(damage1 * rhythm.attack);

# deal 1x attack, 0.05x max health self damage if no kill
func daylight_job(enemies : Array[Enemy], rhythm : Rhythm):
	var damage = 1;
	var target = enemies[0];
	var self_damage = 0.05;
	
	target.damage(damage * rhythm.attack);
	if target.health > 0:
		gamemanager.damage_player(self_damage * gamemanager.max_player_health);

# im not even attempting to describe this move here just delete when we get literally any better option
func last_resort(enemies : Array[Enemy], rhythm : Rhythm):
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

# heal 0.1x max health
func heal(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 0.1;
	
	gamemanager.heal_player(heal * gamemanager.max_player_health);

# heal 0.2x missing health
func restore(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 0.2;
	
	gamemanager.heal_player(heal * (gamemanager.max_player_health - gamemanager.player_health));
