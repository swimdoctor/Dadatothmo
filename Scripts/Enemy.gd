class_name Enemy
extends Area2D

@onready var rhythm: Rhythm = $"../../.."

@export var max_health = 30
@export var health: int # how many times the enemy can be hit
@export var interval: int

@export var attack_pattern: Array[EnemyMove] # a list of strings for the enemies attack pattern
var curr_attack: int

var tick: int = 0

func _ready() -> void:
	print("ADDED", self.name)
	gamemanager.current_enemies.append(self)
	rhythm.beatHit.connect(enemyBeat)

func enemyBeat(downbeat: bool):
	tick += 1
	if tick >= interval:
		tick = 0
		
		# do da move
		var move = attack_pattern[curr_attack]
		
		$AttackSound.stream = move.sound
		$AttackSound.play()
		
		$Spark.texture = move.spark_image
		$Spark.self_modulate.a = 1.0
		print($Spark.self_modulate.a)
		create_tween().tween_property($Spark, "self_modulate:a", 0, 1)
		
		move.enact_on_world()
		curr_attack = (curr_attack + 1) % len(attack_pattern)

var hit_time: float = 0
func damage(by):
	health -= by;
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
	if hit_time > 0:
		hit_time -= delta;
		$EnemySprite.frame = 1;
	else:
		$EnemySprite.frame = 0;
		
	$HealthBar.value = lerp($HealthBar.value, float(health), 0.1);
	$HealthBar.max_value = max_health;
	
# _process (delta)
	# - fires attacks periodically based on tempo and attack pattern
# attack (attack_type: string)
	# - carries out the attack, sending events and modifying stats as required
