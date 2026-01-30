extends Control

var arrowUI

func _ready():
	arrowUI = $ArrowUi;
	
	arrowUI.set_pattern(5);

func _input(event : InputEvent):
	if event is InputEventKey and event.pressed:
		# increment
		if event.keycode == KEY_SPACE:
			arrowUI.increment();
		# reset
		if event.keycode == KEY_R:
			arrowUI.reset();     
