extends CharacterBody2D

const VELOCIDAD = 400.0

# Vitalidad
var vitalidad: int = 10

# Proyectil
var proyectil = preload("res://scenes/Proyectil_reimu.tscn")
var posicion_aparicion_proyectil:Marker2D

# Escudo
var escudo = preload("res://scenes/Escudo.tscn")
var escudo_instanciado = null
var cooldown_escudo: float = 10.0
var escudo_disponible = true
var tiempo_restante_cooldown = 0.0

# Label cooldown escudo
var escudo_cooldown_label: RichTextLabel

# Animación escudo
var animacion_escudo_regenerandose: AnimatedSprite2D

# Señal muerto
signal reimu_muerta

# Señal pierde HP
signal recibe_dmg

func _ready():
	posicion_aparicion_proyectil = $AparicionProyectil
	escudo_cooldown_label = $EscudoCooldownLabel
	animacion_escudo_regenerandose = $EscudoRegenerandoseAnimacion
	animacion_escudo_regenerandose.visible = false
	
	escudo_cooldown_label.visible = false

# Recibe los controles de movimiento.
func recibir_input():
	var direccion = Input.get_vector("dpad_left", "dpad_right", "dpad_up", "dpad_down")
	
	if Input.is_action_pressed("Focus"):
		velocity = direccion * VELOCIDAD / 2.5
	else:
		velocity = direccion * VELOCIDAD

func disparar():
	if Input.is_action_just_pressed("Disparo"):
		var reimu_proyectil = proyectil.instantiate()
		reimu_proyectil.global_position = posicion_aparicion_proyectil.global_position
		get_parent().add_child(reimu_proyectil)

func generar_escudo():
	if Input.is_action_just_pressed("Escudo") and escudo_disponible and escudo_instanciado == null:
		
		# Lanzamos escudo
		lanzar_escudo()
		
		# Lo metemos en cooldown
		escudo_cooldown()

func lanzar_escudo():
	escudo_instanciado = escudo.instantiate()
	escudo_instanciado.global_position = posicion_aparicion_proyectil.global_position + Vector2(0, -50)
	get_parent().add_child(escudo_instanciado)

# Cooldown del escudo
func escudo_cooldown():
	escudo_disponible = false
	tiempo_restante_cooldown = cooldown_escudo
	
	# Se muestran label y animación
	escudo_cooldown_label.visible = true 
	animacion_escudo_regenerandose.visible = true
	animacion_escudo_regenerandose.play()
	
	# Temporizador para actualizar el tiempo restante dinámicamente
	while tiempo_restante_cooldown > 0:
		await get_tree().process_frame
		tiempo_restante_cooldown -= get_process_delta_time()
		actualizar_cooldown_label()
	
	escudo_disponible = true
	actualizar_cooldown_label()
	
	escudo_cooldown_label.visible = false
	animacion_escudo_regenerandose.visible = false

func actualizar_cooldown_label():
	if escudo_disponible:
		escudo_cooldown_label.text = "Escudo listo"
	else:
		escudo_cooldown_label.text = str(snappedf(tiempo_restante_cooldown, 0.1))

func recibir_dmg():
	print("Daño recibido")

	vitalidad -= 1 
	emit_signal("recibe_dmg")
	
	# Muerte del jugador al perder la vitalidad
	if vitalidad <= 0:
		morir()

func morir():
	queue_free()
	emit_signal("reimu_muerta")


# Efectúa el movimiento
func _physics_process(delta: float) -> void:
	recibir_input()
	move_and_slide()
	disparar()
	generar_escudo()
