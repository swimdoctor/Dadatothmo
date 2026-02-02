extends Control

var arrowUI
var arrowUI_scene = preload("res://Scenes/arrowUI/arrow_ui.tscn");
var base_pattern: Array[Move.Direction] = [
	Move.Direction.RIGHT, 
	Move.Direction.UP, 
	Move.Direction.LEFT, 
	Move.Direction.DOWN	
];

func _ready():
	arrowUI = arrowUI_scene.instantiate();
	add_child(arrowUI);
	
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
		
		# set completion
		if(event.keycode == KEY_0):
			arrowUI.set_completed_moves(0);
		if(event.keycode == KEY_1):
			arrowUI.set_completed_moves(1);
		if(event.keycode == KEY_2):
			arrowUI.set_completed_moves(2);
		if(event.keycode == KEY_3):
			arrowUI.set_completed_moves(3);
		if(event.keycode == KEY_4):
			arrowUI.set_completed_moves(4);
		if(event.keycode == KEY_5):
			arrowUI.set_completed_moves(5);
