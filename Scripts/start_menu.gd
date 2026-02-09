extends Control

func _on_play_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.Fighting)
	print_debug("Play!")


func _on_quit_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.GameOver)
	print_debug("Quit!")

func _on_menu_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.MainMenu)
