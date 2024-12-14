extends CharacterBody2D

const SPEED = 2

# Temporizador para el movimiento lateral enemigo
var timer_movimiento
# Temporizador para los disparos enemigos
var timer_disparo

# Controla que está en mitad de la animación de disparo
var en_animacion_disparo = false

# Punto de origen de desplazamiento
var origen = 0
# Rango de movimiento
var rango_movimiento = 60
# Dirección del movimiento
var direccion = 1

# Sprite
var sprite

# Proyectil
var proyectil = preload("res://scenes/proyectil_remilia.tscn")
var posicion_aparicion_proyectil:Marker2D

signal remilia_eliminada

func _ready() -> void:
	# Inicia el timer de movimientod
	timer_movimiento = $TimerMovimiento
	timer_movimiento.start()
	origen = self.position.x
	
	# Sprite 2D
	sprite = $Sprite2D
	
	# Proyectil
	posicion_aparicion_proyectil = $PosicionAparicionProyectil

# Evento de ataque
func atacar():
	if en_animacion_disparo: 
		return
	
	en_animacion_disparo = true
	
	# Ocultar sprite base durante ataque
	sprite.visible = false
	
	#Obtener sprite animación y reproducirla
	var disparo_animacion = $DisparoAnimacion
	disparo_animacion.visible = true
	disparo_animacion.play("atacar")

# Dispara el proyectil
func disparar_proyectil():
	var remilia_proyectil = proyectil.instantiate()
	remilia_proyectil.global_position = posicion_aparicion_proyectil.global_position
	get_parent().add_child(remilia_proyectil)

# Cuando el enemigo muere
func morir():
	emit_signal("remilia_eliminada", self)
	call_deferred("queue_free")

# Cuando el timer de movimiento completa un ciclo
func _on_timer_movimiento_timeout() -> void:
	self.position.x += SPEED * direccion

	if self.position.x >= rango_movimiento + origen or self.position.x < origen - rango_movimiento:
		self.direccion *= -1

# Cuando la animación termina
func _on_disparo_animacion_animation_finished() -> void:

	# Llama al disparo del proyectil
	disparar_proyectil()
	
	# Ocultar animación disparo
	$DisparoAnimacion.visible = false
	
	# Mostrar animación base y ocultar la de disparo
	sprite.visible = true
	en_animacion_disparo = false
