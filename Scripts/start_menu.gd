extends Control

func _on_play_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.Map)
	print_debug("Play!")


func _on_quit_button_pressed() -> void:
	print_debug("Quit!")
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	gamemanager.change_gamestate(gamemanager.GameState.MainMenu)
