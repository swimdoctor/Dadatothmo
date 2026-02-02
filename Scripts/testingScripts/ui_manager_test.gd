extends Control

var arrowUI
var base_pattern: Array[Move.Direction] = [
	Move.Direction.RIGHT, 
	Move.Direction.UP, 
	Move.Direction.LEFT, 
	Move.Direction.DOWN	
];

func _ready():
	arrowUI = $ArrowUi;
	
	arrowUI.set_pattern(base_pattern);

func randomInput():
	var pattern: Array[Move.Direction] = [];
	var rng = RandomNumberGenerator.new()
	for i in 5:
		pattern.push_back(base_pattern[randi_range(0, 3)]);
	return pattern;

func _input(event : InputEvent):
	if event is InputEventKey and event.pressed:
		# increment
		if event.keycode == KEY_SPACE:
			arrowUI.increment();
		#decrement
		if event.keycode == KEY_BACKSPACE:
			arrowUI.decrement();
		# reset
		if event.keycode == KEY_R:
			arrowUI.reset();  
		if event.keycode == KEY_N:
			arrowUI.set_pattern(randomInput());   
