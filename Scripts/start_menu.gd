extends Control

@onready var play_button = $"CanvasLayer/Play Button"
@onready var quit_button = $"CanvasLayer/Quit Button"

func _on_play_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.Fighting)
	print_debug("Play!")


func _on_quit_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.GameOver)
	print_debug("Quit!")
