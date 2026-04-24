class_name Enemy
extends Area2D

@onready var rhythm: Rhythm = $"../../.."

@export var max_health = 30
@export var health: int # how many times the enemy can be hit
@export var interval: Array[int];
@export var base_interval: Array[int];

@export var attack_pattern: Array[EnemyMove] # a list of strings for the enemies attack pattern
var curr_attack: int

var enemy_name: String = ""
var description: String = ""
var id: int

var tick: int = 0
var attacking: float = 0

"""
func _init(id = null, name = "", description = "", sprite = null, health = 0, attacks = Array[EnemyMove]) -> void:
	self.id = id
	self.enemy_name = name
	self.description = description
	self.sprite = null
	self.health = health
	self.attack_pattern = attacks
"""

func _ready() -> void:
	print("ADDED", self.name)
	gamemanager.current_enemies.append(self)
	rhythm.beatHit.connect(enemyBeat)
	
	if gamemanager.pending_enemy_data.size() > 0:
		apply_data(gamemanager.pending_enemy_data[0])
	
	# initialize health bar
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health

func apply_data(data: EnemyData) -> void:
	enemy_name = data.enemy_name
	description = data.description
	max_health = data.max_health
	health = data.max_health
	attack_pattern = data.attack_pattern
	interval = data.interval;
	base_interval = data.base_interval;
	
	var sprite_frames = SpriteFrames.new()
	#sprite_frames.add_frame("default", load(data.sprite_path), 0)
	var spriteSheet = load(data.sprite_path)
	for i in range(5):
		var atlas = AtlasTexture.new()
		atlas.atlas = spriteSheet
		atlas.region = Rect2(64 * i, 0, 64, 64)
		sprite_frames.add_frame("default", atlas)
	$EnemySprite.sprite_frames = sprite_frames
	#$EnemySprite.play("default")

func enemyBeat(downbeat: bool):
	tick += 1
	
	for i in interval.size():
		interval[i] -= 1;
		if(interval[i] <= 0):
			var move = attack_pattern[i];
			
			if(move.sound):
				$AttackSound.stream = move.sound
				$AttackSound.play()
		
			if(move.spark_image):
				$Spark.texture = move.spark_image
				$Spark.self_modulate.a = 1.0
				print($Spark.self_modulate.a)
				create_tween().tween_property($Spark, "self_modulate:a", 0, 1)
				
			#if(move.sprite):
			$Spark.texture = move.sprite
			$Spark.self_modulate.a = 1.0
			create_tween().tween_property($Spark, "self_modulate:a", 0, 1)
			move.do_move(gamemanager.current_enemies, rhythm)
			curr_attack = (curr_attack + 1) % len(attack_pattern)
			
			interval[i] = base_interval[i];
			attacking = 1

var hit_time: float = 0
func damage(by):
	health -= by;
	print(health);
	# update health bar
	$HealthBar.value = health;
	$EnemySprite.self_modulate.g = 0.0
	$EnemySprite.self_modulate.b = 0.0
	create_tween().tween_property($EnemySprite, "self_modulate:g", 1, 0.75)
	create_tween().tween_property($EnemySprite, "self_modulate:b", 1, 0.75)
	
	if health <= 0:
		$DieSound.play()
		var tween = create_tween()
		tween.tween_property($EnemySprite, "self_modulate:a", 0, 1).set_delay(0.8)
		tween.tween_callback(Callable(self, "queue_free")).set_delay(0.8)
		hit_time = 20
		#Later, wait for all enemies to be dead
		gamemanager.remove_enemy(self)
		
	else:
		hit_time = 0.5
		$OuchSound.play()

func _process(delta):
	if attacking > 0:
		$EnemySprite.play("default")
		attacking -= delta
		print(delta)
	else:
		$EnemySprite.frame = 0;
	
# _process (delta)
	# - fires attacks periodically based on tempo and attack pattern
# attack (attack_type: string)
	# - carries out the attack, sending events and modifying stats as required
