class_name EnemyMoveList
extends Node

enum EnemyMoveName {
	STRIKE,
	OTHER,
	ROADIE_STRIKE, 
	FROGLINSPLODE_STRIKE,
	FROGLINSPLODE_EXPLODE,
	GREG_STRIKE,
	MIKE_STRIKE,
	MIKE_HEAL
}

func get_enemy_move(enemy_move_name : EnemyMoveName) -> EnemyMove:
	return new_enemy_move(enemy_move_name);

func new_enemy_move(enemy_move : EnemyMoveName):
	var name : String;
	var path : String;
	var method : String;
	var description : String;
	
	match enemy_move:
		EnemyMoveName.STRIKE: 
			name = "Strike";
			path = "res://Images/Test/IconRoughSword.png";
			method = "strike";
			description = "Deals 30 damage.";
			
		EnemyMoveName.OTHER: 
			name = "Strike";
			path = "res://Images/Test/IconRoughSword.png";
			method = "strike";
			description = "Deals 30 damage.";
		
		EnemyMoveName.ROADIE_STRIKE:
			name = "Roadie Strike";
			path = 'res://Images/Test/IconRoughSword.png';
			method = 'roadie_strike';
			description = "Deals 12 damage.";
		
		EnemyMoveName.FROGLINSPLODE_STRIKE:
			name = "Froglinsplode Strike";
			path = 'res://Images/Test/IconRoughSword.png';
			method = 'froglinsplode_strike';
			description = "Deals 5 damage.";
		
		EnemyMoveName.FROGLINSPLODE_EXPLODE:
			name = "Froglinsplode Explode";
			path= 'res://Images/Test/IconRoughSword.png';
			method = 'froglinsplode_explode';
			description = "Deals 50 damage and explodes.";
		
		EnemyMoveName.GREG_STRIKE:
			name = 'Greg Strike';
			path = 'res://Images/Test/IconRoughSword.png';
			method = 'greg_strike';
			description = 'Deals 8 damage.';
		
		EnemyMoveName.MIKE_STRIKE:
			name = "Mike Strike";
			path = 'res://Images/Test/IconRoughSword.png';
			method = 'mike_strike';
			description = 'Deals 8 damage';
		
		EnemyMoveName.MIKE_HEAL:
			name = 'Mike Heal';
			path = 'res://Images/Test/IconRoughSword.png';
			method = 'mike_heal';
			description = 'Heals 5 health';

	return EnemyMove.new(enemy_move, name, description, load(path), Callable(self, method));

# deal 30 damage to player
func strike(enemies : Array[Enemy], rhythm : Rhythm, user : Enemy):
	gamemanager.damage_player(15)

# deal 12 damage to player
func roadie_strike(enemies : Array[Enemy], rhythm : Rhythm, user : Enemy):
	gamemanager.damage_player(12);

# deal 5 damage to player
func froglinsplode_strike(enemies : Array[Enemy], rhythm: Rhythm, user : Enemy):
	gamemanager.damage_player(5);

# deal 50 damage to player and die
func froglinsplode_explode(enemies : Array[Enemy], rhythm: Rhythm, user : Enemy):	
	user.damage(99999);
	
	gamemanager.damage_player(50);

# deal 8 damage to player
func greg_strike(enemies : Array[Enemy], rhythm : Rhythm, user : Enemy):
	gamemanager.damage_player(8);

# deal 8 damage
func mike_strike(enemies : Array[Enemy], rhythm : Rhythm, user : Enemy):
	gamemanager.damage_player(8);

# heal for 5
func mike_heal(enemies : Array[Enemy], rhythm : Rhythm, user : Enemy):
	# replace with heal function eventually
	user.health = min(user.health + 5, user.max_health);
