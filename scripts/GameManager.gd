extends Node2D


# Escena de Game Over
var game_over_scene = preload("res://scenes/Game_Over.tscn")
var victoria_scene = preload("res://scenes/Victoria.tscn")

# Jugador / Reimu
var reimu
var grupo_remilias

# Vitalidad
var vitalidad_reimu: int = 0
var vitalidad_reimu_txt: RichTextLabel

func _ready() -> void:
	
	# Carga de elementos de la escena.
	reimu = $Reimu 
	vitalidad_reimu = reimu.vitalidad
	vitalidad_reimu_txt = $VitalidadReimu
	vitalidad_reimu_txt.text = str(vitalidad_reimu)
	
	grupo_remilias = $GrupoRemilias

	# Señal de muerte del jugador
	reimu.connect("reimu_muerta", Callable(self, "_on_reimu_muerta"))

	# Señal de daño del jugador
	reimu.connect("recibe_dmg", Callable(self, "_on_reimu_recibe_dmg"))
	
	# Señal de victoria del jugador
	grupo_remilias.connect("victoria", Callable(self, "_on_victoria"))

# Evento cuando el jugador muere
func _on_reimu_muerta():
	# Cambiar a la escena de Game Over
	get_tree().call_deferred("change_scene_to_packed", game_over_scene)
	
func _on_reimu_recibe_dmg():
	vitalidad_reimu -= 1
	vitalidad_reimu_txt.text = str(vitalidad_reimu)

func _on_victoria():
	# Cambiar a la escena de Game Over con Victoria
	get_tree().call_deferred("change_scene_to_packed", victoria_scene)

func _on_area_game_over_body_entered(body: Node2D) -> void:
	if body.is_in_group("Remilia"):
		get_tree().change_scene_to_packed(game_over_scene)
