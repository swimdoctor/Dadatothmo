class_name EnemyList
extends Node

enum EnemyName {
	GOBLIN,
	BARDIC_BOYS,
	ROADIE,
	FROGLINSPLODE,
	GREG_TEMPLE,
	MIKE_WIRE,
	TODD_BEARSOOS,
	ICE_SPIDER
}

func set_enemy(enemy_name : EnemyName) -> void:
	return;
	#Set current opponent to enemy
	#Later need to support multi-enemy combats

func random_enemy() -> EnemyName:
	return randi() % EnemyName.size()

func random_enemy_data() -> EnemyData:
	return new_enemy(random_enemy())

func new_enemy(enemy : EnemyName):
	var enemy_name : String;
	var description : String;
	
	## File path to the enemy's sprite
	var sprite_path : String;
	
	## Amount of health the enemy spawns with
	var max_health : int;
	
	## enemy move variable for making this next bit more compact
	var em = enemymovelist.EnemyMoveName;
	
	## Enemy will perform attacks in this order
	var attack_pattern : Array[EnemyMove];
	var attack_names : Array[enemymovelist.EnemyMoveName];
	
	
	match enemy:
		EnemyName.GOBLIN:
			enemy_name = "Golbin the Gobbin";
			description = "Can strike";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_names = [em.STRIKE];
			
		EnemyName.BARDIC_BOYS:
			enemy_name = "Bardic Boys";
			description = "They've got each other's backs";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 200;
			attack_names = [em.STRIKE];
			
		EnemyName.FROGLINSPLODE:
			enemy_name = "His Royal Magesty, Froginsplode";
			description = "King of the goblin sect. Wields explosives.";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 500;
			attack_names = [em.STRIKE];
		
		EnemyName.ROADIE:
			enemy_name = "Roadie";
			description = "Not the musical type.";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 150;
			attack_names = [em.STRIKE];
		
		EnemyName.GREG_TEMPLE:
			enemy_name = "Greg Temple";
			description = "The Temple name is renowned throughout the Underground.";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 600;
			attack_names = [em.STRIKE];
		
		EnemyName.MIKE_WIRE:
			enemy_name = "Mike Wire";
			description = "Leader of the Choir";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 80;
			attack_names = [em.STRIKE];
		
		EnemyName.TODD_BEARSOOS:
			enemy_name = "Todd Bearsoos";
			description = "Wants to make you sledepy";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 150;
			attack_names = [em.STRIKE];
		
		EnemyName.ICE_SPIDER:
			enemy_name = "Ice Spider";
			description = "ICE. SPIDER.";
			sprite_path = "res://Images/Test/IconRoughSword.png";
			max_health = 300;
			attack_names = [em.STRIKE];
			
	for attack in attack_names:
		attack_pattern.append(enemymovelist.new_enemy_move(attack));

	return #Enemy.new(enemy, enemy_name, description, load(path), max_health, attack_pattern);
