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
	return randi() % (EnemyName.size() - 1) + 1

func random_enemy_data() -> EnemyData:
	return new_enemy(random_enemy())

func new_enemy(enemy : EnemyName) -> EnemyData:
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
			enemy_name = "Golbin the Gobbin"
			description = "Can strike"
			sprite_path = "res://Images/Test/Enemies/GoblinSprites.png"
			max_health = 30
			attack_names = [em.STRIKE]
			
		EnemyName.BARDIC_BOYS:
			enemy_name = "Bardic Boys"
			description = "They've got each other's backs"
			sprite_path = "res://Images/Test/Enemies/BardBoyMarisa.png"
			max_health = 50
			attack_names = [em.STRIKE]
			
		EnemyName.FROGLINSPLODE:
			enemy_name = "His Royal Magesty, Froginsplode"
			description = "King of the goblin sect. Wields explosives."
			sprite_path = "res://Images/Test/Enemies/Froglinsplode.png"
			max_health = 90
			attack_names = [em.STRIKE]
		
		EnemyName.ROADIE:
			enemy_name = "Roadie"
			description = "Not the musical type."
			sprite_path = "res://Images/Test/Enemies/Roadie.png"
			max_health = 40
			attack_names = [em.STRIKE]
		
		EnemyName.GREG_TEMPLE:
			enemy_name = "Greg Temple"
			description = "The Temple name is renowned throughout the Underground."
			sprite_path = "res://Images/Test/Enemies/GregTemple.png"
			max_health = 100
			attack_names = [em.STRIKE]
		
		EnemyName.MIKE_WIRE:
			enemy_name = "Mike Wire"
			description = "Leader of the Choir"
			sprite_path = "res://Images/Test/Enemies/MikeWire.png"
			max_health = 25
			attack_names = [em.STRIKE]
		
		EnemyName.TODD_BEARSOOS:
			enemy_name = "Todd Bearsoos"
			description = "Wants to make you sledepy"
			sprite_path = "res://Images/Test/Enemies/ToddBearsoos.png"
			max_health = 45
			attack_names = [em.STRIKE]
		
		EnemyName.ICE_SPIDER:
			enemy_name = "Ice Spider"
			description = "ICE. SPIDER."
			sprite_path = "res://Images/Test/Enemies/IceSpider.png"
			max_health = 70
			attack_names = [em.STRIKE]
			
	for attack in attack_names:
		attack_pattern.append(enemymovelist.new_enemy_move(attack));

	var data = EnemyData.new()
	data.enemy_name = enemy_name
	data.description = description
	data.sprite_path = sprite_path
	data.max_health = max_health
	data.attack_pattern = attack_pattern
	return data
