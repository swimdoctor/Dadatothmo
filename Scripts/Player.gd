extends RigidBody2D

@export var speed = 50
var facing = 1;

func _physics_process(delta):
	var velocity = Vector2();
	
	if Input.is_action_pressed("up"):
		velocity.y -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if Input.is_action_pressed("down"):
		velocity.y += speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	
	if velocity.x != 0:
		if facing != sign(velocity.x):
			facing = sign(velocity.x)
			$Sprite.flip_h = facing == -1
	linear_velocity = velocity;
	
