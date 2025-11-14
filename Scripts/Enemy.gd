class_name Enemy
extends Area2D

@export var max_health = 30
@export var health: int # how many times the enemy can be hit
@export var tempo: int # speed of enemy encounter
@export var attack_pattern: Array[String] # a list of strings for the enemies attack pattern

func _ready() -> void:
	print("ADDED", self.name)
	gamemanager.current_enemies.append(self)
	

var hit_time: float = 0
func damage(by):
	health -= by;
	if health <= 0:
		$DieSound.play()
		var tween = create_tween()
		tween.tween_property($EnemySprite, "self_modulate:a", 0, 1)
		tween.tween_callback(Callable(self, "queue_free")).set_delay(0.8)
		hit_time = 20
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
