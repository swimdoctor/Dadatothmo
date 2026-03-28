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

func add_move(move_name : MoveName) -> void:
	gamemanager.move_list.append(new_move(move_name));
	
func remove_move(move_name : MoveName) -> bool: 
	for i in gamemanager.move_list.size():
		if gamemanager.move_list[i].id == move_name:
			gamemanager.move_list.remove_at(i);
			return true;
	return false;

func remove_at(index : int) -> bool:
	if(index >= gamemanager.move_list.size()):
		return false;
	gamemanager.move_list.remove_at(index);
	return true;

func replace_move(old_move_name : MoveName, new_move_name : MoveName) -> bool:
	for i in gamemanager.move_list.size():
		if gamemanager.move_list[i].id == old_move_name:
			gamemanager.move_list[i] = new_move(new_move_name);
			return true;
	return false;

func replace_at(old_index : int, new_move_name : MoveName) -> bool :
	if(old_index >= gamemanager.move_list.size()):
		return false;
	gamemanager.move_list[old_index] = new_move(new_move_name);
	return true;

func random_move() -> MoveName:
	return randi() % MoveName.size();

func new_move(move : MoveName):
	var name : String;
	var path : String;
	var pattern : Array[Move.Direction];
	var method : String;
	var description : String
	
	match move:
		MoveName.STRIKE: 
			name = "Strike";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.RIGHT];
			method = "strike";
			description = "Deal 50% Attack stat to first enemy."
		MoveName.FIREBALL:
			name = "Fireball";
			path = "res://Images/Test/IconRoughFire.png";
			pattern = [Move.Direction.LEFT, Move.Direction.RIGHT, Move.Direction.LEFT, Move.Direction.RIGHT];
			method = "fireball";
			description = "Deal 100% Attack stat to the first enemy."
		MoveName.REST:
			name = "Rest";
			path = "res://Images/Test/IconRoughHealth.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.UP, Move.Direction.UP, Move.Direction.RIGHT];
			method = "rest";
			description = "Heal 20HP."
		MoveName.MAGIC_MISSILE:
			name = "Magic Missile";
			path = "res://Images/Test/IconRoughFire.png"
			pattern = [Move.Direction.UP, Move.Direction.LEFT, Move.Direction.RIGHT, Move.Direction.UP];
			method = "magic_missile";
			description = "Deal 40% Attack stat to all enemies."
		MoveName.DOUBLE_ATTACK:
			name = "Double Attack";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.LEFT, Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.DOWN];
			method = "double_attack";
			description = "Deal 40% Attack stat twice to the first enemy."
		MoveName.SIMPLE_DIE:
			name = "Simple Die";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.RIGHT];
			method = "simple_die";
			description = "Roll a 4 sided die. Deal 40% Attack stat times the outcome to the first enemy."
		MoveName.COIN_FLIP:
			name = "Coin Flip";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.DOWN, Move.Direction.UP];
			method = "coin_flip";
			description = "Flip a coin. If heads, deal 120% Attack stat. If tails, deal 50% Attack stat."
		MoveName.HIGH_ROLLER:
			name = "High Roller";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.LEFT, Move.Direction.UP, Move.Direction.DOWN, Move.Direction.RIGHT];
			method = "high_roller";
			description = "Roll a twelve sided die. Deal 50% Attack stat times the outcome of the roll."
		MoveName.ALL_IN:
			name = "All In";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.RIGHT, Move.Direction.UP, Move.Direction.LEFT, Move.Direction.DOWN];
			method = "all_in";
			description = "Roll a six sided die. If the roll is 6, deal 250% Attack stat. Otherwise deal 50% Attack stat."
		MoveName.MONEYMAKER:
			name = "Moneymaker";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.DOWN, Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.LEFT, Move.Direction.UP];
			method = "moneymaker";
			description = "Deal 50% Attack and roll two six sided dice. For each 6 that is rolled, increase the damage of this attack by an additive 150% Attack."
		MoveName.SNEAK_ATTACK:
			name = "Sneak Attack";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.LEFT];
			method = "sneak_attack";
			description = "Deal 65% Attack stat to the enemy with the lowest HP."
		MoveName.SNIPE:
			name = "Snipe";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.DOWN];
			method = "snipe";
			description = "Deal 50% Attack. Deal 150% Attack to the second enemy. If there is only one enemy, instead deal 100% Attack"
		MoveName.DAYLIGHT_JOB:
			name = "Daylight Job";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.RIGHT, Move.Direction.DOWN];
			method = "daylight_job";
			description = "Deal 100% Attack to the enemy with the lowest HP. If this damage fails to kill, take 5% Max HP self damage."
		MoveName.LAST_RESORT:
			name = "Last Resort";
			path = "res://Images/Test/IconRoughSword.png";
			pattern = [Move.Direction.UP, Move.Direction.DOWN, Move.Direction.LEFT, Move.Direction.LEFT, Move.Direction.RIGHT, Move.Direction.RIGHT];
			method = "last_resort";
			description = "Go big or go home."
		MoveName.HEAL:
			name = "Heal";
			path = "res://Images/Test/IconRoughHealth.png";
			pattern = [Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.DOWN, Move.Direction.LEFT, Move.Direction.UP];
			method = "heal";
			description = "Heal 10% Max HP."
		MoveName.RESTORE:
			name = "Restore";
			path = "res://Images/Test/IconRoughHealth.png";
			pattern = [Move.Direction.UP, Move.Direction.RIGHT, Move.Direction.LEFT, Move.Direction.UP];
			method = "restore";
			description = "Heal 20% missing HP."
	
	return Move.new(move, name, description, load(path), pattern, Callable(self, method));

# deal 0.5x attack stat to first enemy
func strike(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 1x attack stat to first enemy
func fireball(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 1;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# heal 20 health
func rest(enemies : Array[Enemy], rhythm : Rhythm):
	var heal = 20;
	
	gamemanager.heal_player(heal);

# deal 0.4x attack stat to all enemies
func magic_missile(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 0.4;
	
	for enemy in enemies:
		enemy.damage(damage * rhythm.attack);

# deal 0.4x attack to first enemy twice
func double_attack(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 0.4;
	var target = enemies[0];
	
	for i in 2:
		target.damage(damage * rhythm.attack);

# deal 1-4 * 0.4x attack
func simple_die(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = randi_range(1, 5) * 0.4;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 1.2x or 0.5x attack to first enemy
func coin_flip(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 1.2 if randf() < 0.5 else 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 1-12 * 0.5x attack
func high_roller(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = randi_range(1, 13) * 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 0.5x attack on crit or 2.5x on crit
func all_in(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 2.5 if randf() < 0.166666 else 0.5;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 0.5x attack plus 1.5x for each crit
func moneymaker(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 0.5;
	for i in 2:
		damage += 1.5 if randf() < 0.166666 else 0;
	var target = enemies[0];
	
	target.damage(damage * rhythm.attack);

# deal 0.65x attack to lowest health enemy
func sneak_attack(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
	var damage = 0.65;
	var target = enemies[0];
	for enemy in enemies:
		if enemy.health < target.health:
			target = enemy;
	
	target.damage(damage * rhythm.attack);

# deal 0.5x attack and 1.5x attack to second enemy, or 1x attack if none
func snipe(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
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
	if(enemies.size() < 1):
		return;
	
	var damage = 1;
	var target = enemies[0];
	var self_damage = 0.05;
	
	target.damage(damage * rhythm.attack);
	if target.health > 0:
		gamemanager.damage_player(self_damage * gamemanager.max_player_health);

# im not even attempting to describe this move here just delete when we get literally any better option
func last_resort(enemies : Array[Enemy], rhythm : Rhythm):
	if(enemies.size() < 1):
		return;
	
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
