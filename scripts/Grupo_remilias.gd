extends Node2D

var remilia = preload("res://scenes/Remilia.tscn")

# Timer disparo
var timer_disparo

# Lista de remilias
var lista_remilias = []

# Dirección del movimiento de las remilias
var direccion_grupo: int = 1

# Velocidad de movimiento de las remilias
var velocidad: float = 40.0
var incremento_velocidad: float = 5.0 # Incremento de velocidad

# Límites de la pantalla
var limite_izquierdo: float = 0
var limite_derecho: float = 800

# Victoria señal
signal victoria

func _ready() -> void:
	timer_disparo = $TimerDisparo
	limite_derecho = get_viewport().get_visible_rect().size.x - 20
	limite_izquierdo = 20
	
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
	mover_remilias(delta)
	
func mover_remilias(delta: float) -> void:
	
	#Identificar los extremos
	var remilia_limite_izquierda: Node2D = null
	var remilia_limite_derecha: Node2D = null
	
	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi):
				if remilia_limite_izquierda == null or remi.position.x < remilia_limite_izquierda.position.x:
					remilia_limite_izquierda = remi
				if remilia_limite_derecha == null or remi.position.x > remilia_limite_derecha.position.x:
					remilia_limite_derecha = remi
	
	# Cambio de dirección por límite de pantalla
	if remilia_limite_izquierda and remilia_limite_izquierda.position.x <= limite_izquierdo:
		direccion_grupo = 1
		velocidad += incremento_velocidad
		descender_remilias()
	elif remilia_limite_derecha and remilia_limite_derecha.position.x >= limite_derecho:
		direccion_grupo = -1
		velocidad += incremento_velocidad # Aumenta velocidad al cambiar dirección
		descender_remilias()
		
	# Mover a todos los enemigos en la dirección actual
	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi):
				remi.position.x += direccion_grupo * velocidad * delta

func descender_remilias() -> void:
	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi):
				remi.position.y += 20
				
# Control del aumento de velocidad basado en el rango
func ajustar_velocidad_enemigos(nueva_velocidad):
	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi):
				remi.SPEED = nueva_velocidad

func _on_timer_disparo_timeout() -> void:
	var lista_remilias_vivas = []

	for fila in lista_remilias:
		for remi in fila:
			if is_instance_valid(remi) and !remi.is_queued_for_deletion():
				lista_remilias_vivas.append(remi)

	if len(lista_remilias_vivas) > 0:
		var remi_seleccionada = int(floor(randf_range(0, len(lista_remilias_vivas))))
		lista_remilias_vivas[remi_seleccionada].atacar()
		timer_disparo.wait_time = randf_range(0.068, 0.103)
