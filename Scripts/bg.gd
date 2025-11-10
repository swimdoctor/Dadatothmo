extends TextureRect

const SPEED = 32.0;
func _process(delta):
	position.x += SPEED * delta
	position.y += SPEED * delta
	if position.x > 0: position.x -= 128
	if position.y > 0: position.y -= 128
