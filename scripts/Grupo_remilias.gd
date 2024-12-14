extends Node2D

var remilia = preload("res://scenes/Remilia.tscn")

# Timer disparo
var timer_disparo

# Lista de remilias
var lista_remilias = []

# Victoria señal
signal victoria

func _ready() -> void:
	timer_disparo = $TimerDisparo
	
	for i in range(6):
		lista_remilias.append([])
		
		for j in range(12):
			var remilia_instancia = remilia.instantiate()
			remilia_instancia.global_position = Vector2(80 + 40 * j,30 + 50 * i)
			self.add_child(remilia_instancia)
			
			# Agregamos cada Remilia a la lista
			lista_remilias[i].append(remilia_instancia)
			
			remilia_instancia.connect("remilia_eliminada", Callable(self, "eliminar_remilia"))

func eliminar_remilia(remi):
	for fila in lista_remilias:
		if remi in fila:
			fila.erase(remi)
			print("Remilia Eliminada")
			print(lista_remilias)
			
	# Comprobar si has eliminado a todos los enemigos
	if comprobar_victoria():
		print("¡Victoria!")
		game_over_victoria()
			
func comprobar_victoria() -> bool:
	# Comprueba si no quedan remilias en la lista
	for fila in lista_remilias:
		if fila.size() > 0:
			return false
	return true
	
func game_over_victoria():
	emit_signal("victoria")

func _process(delta: float) -> void:
	pass

func _on_timer_descender_timeout() -> void:
	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi):
				remi.position.y += 25

func _on_timer_disparo_timeout() -> void:
	var lista_remilias_vivas = []

	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi) and !remi.is_queued_for_deletion():
				lista_remilias_vivas.append(remi)

	if len(lista_remilias_vivas) > 0:
		var remi_seleccionada = int(floor(randf_range(0, len(lista_remilias_vivas))))
		lista_remilias_vivas[remi_seleccionada].atacar()
		timer_disparo.wait_time = randf_range(0.08, 0.11)
