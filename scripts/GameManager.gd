extends Node2D


# Escena de Game Over
var game_over_scene = preload("res://scenes/Game_Over.tscn")

# Jugador / Reimu
var reimu

# Vitalidad
var vitalidad_reimu: int = 10
var vitalidad_reimu_txt: RichTextLabel

func _ready() -> void:
	
	# Carga de elementos de la escena.
	reimu = $Reimu 
	vitalidad_reimu_txt = $VitalidadReimu

	# Señal de muerte del jugador
	reimu.connect("reimu_muerta", Callable(self, "_on_reimu_muerta"))

	# Señal de daño del jugador
	reimu.connect("recibe_dmg", Callable(self, "on_reimu_recibe_dmg"))

# Evento cuando el jugador muere
func _on_reimu_muerta():
	# Cambiar a la escena de Game Over
	get_tree().change_scene_to_packed(game_over_scene)
	
func on_reimu_recibe_dmg():
	vitalidad_reimu -= 1
	vitalidad_reimu_txt.text = str(vitalidad_reimu)
