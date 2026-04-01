class_name EnemyList
extends Node

enum EnemyName {
	GOBLIN,
	BARDIC_BOYS,
	GREG_TEMPLE,
	FROGLINSPLODE,
	ICE_SPIDER,
	MIKE_WIRE,
	ROADIE,
	TODD_BEARSOOS,
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
			description = "Can strike"
			path = "res://Images/Test/IconRoughSword.png";
			max_health = 100;
			attack_pattern = [];
	
	return #Enemy.new(enemy, enemy_name, description, load(path), max_health, attack_pattern);
