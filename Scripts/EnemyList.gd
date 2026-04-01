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
	return randi() % EnemyName.size();

func new_enemy(enemy : EnemyName):
	var enemy_name : String;
	var description : String
	var path : String
	var max_health : int;
	var attack_pattern : Array[EnemyMove];
	
	match enemy:
		EnemyName.GOBLIN:
			enemy_name = "Golbin the Gobbin";
			description = "Can strike";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.BARDIC_BOYS:
			enemy_name = "Bardic Boys";
			description = "They've got each other's backs";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.FROGLINSPLODE:
			enemy_name = "His Royal Magesty, Froginsplode";
			description = "King of the goblin sect. Wields explosives.";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.ROADIE:
			enemy_name = "Roadie";
			description = "Not the musical type.";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.GREG_TEMPLE:
			enemy_name = "Greg Temple";
			description = "The Temple name is renowned throughout the Underground.";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.MIKE_WIRE:
			enemy_name = "Mike Wire";
			description = "Leader of the Choir";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.TODD_BEARSOOS:
			enemy_name = "Todd Bearsoos";
			description = "Wants to make you sledepy";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
		EnemyName.ICE_SPIDER:
			enemy_name = "Ice Spider";
			description = "ICE. SPIDER.";
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
			return;
			
	
	return #Enemy.new(enemy, enemy_name, description, load(path), max_health, attack_pattern);
