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
	
	## Enemy will perform attacks in this order
	var attack_pattern : Array[EnemyMove];

	match enemy:
		EnemyName.GOBLIN:
			enemy_name = "Golbin the Gobbin"
			description = "Can strike"
			sprite_path = "res://Images/Test/IconRoughSword.png"
			max_health = 100
			attack_pattern = [enemymovelist.new_enemy_move(EnemyMoveList.EnemyMoveName.STRIKE)]
		EnemyName.BARDIC_BOYS:
			enemy_name = "Bardic Boys"
			description = "They've got each other's backs"
			sprite_path = "res://Images/Test/Enemies/BardBoyMarisa.png"
			max_health = 200
		EnemyName.FROGLINSPLODE:
			enemy_name = "His Royal Magesty, Froginsplode"
			description = "King of the goblin sect. Wields explosives."
			sprite_path = "res://Images/Test/Froglinsplode.png"
			max_health = 500
		EnemyName.ROADIE:
			enemy_name = "Roadie"
			description = "Not the musical type."
			sprite_path = "res://Images/Test/Roadie.png"
			max_health = 150
		EnemyName.GREG_TEMPLE:
			enemy_name = "Greg Temple"
			description = "The Temple name is renowned throughout the Underground."
			sprite_path = "res://Images/Test/GregTemple.png"
			max_health = 600
		EnemyName.MIKE_WIRE:
			enemy_name = "Mike Wire"
			description = "Leader of the Choir"
			sprite_path = "res://Images/Test/MikeWire.png"
			max_health = 80
		EnemyName.TODD_BEARSOOS:
			enemy_name = "Todd Bearsoos"
			description = "Wants to make you sledepy"
			sprite_path = "res://Images/Test/ToddBearsoos.png"
			max_health = 150
		EnemyName.ICE_SPIDER:
			enemy_name = "Ice Spider"
			description = "ICE. SPIDER."
			sprite_path = "res://Images/Test/IceSpider.png"
			max_health = 300

	var data = EnemyData.new()
	data.enemy_name = enemy_name
	data.description = description
	data.sprite_path = sprite_path
	data.max_health = max_health
	data.attack_pattern = attack_pattern
	return data
