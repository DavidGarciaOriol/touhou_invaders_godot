extends Control

var escena_juego = "res://scenes/Main.tscn"

# Reinicia juego
func _on_reiniciar_pressed() -> void:
	print(escena_juego)
	get_tree().change_scene_to_file(escena_juego)

# Cierra juego
func _on_salir_pressed() -> void:
	get_tree().quit()
