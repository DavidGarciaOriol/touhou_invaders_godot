extends Area2D

# Velocidad inicial del escudo
var velocidad_inicial: Vector2 = Vector2(0, -500)

# Deceleración del escudo
var deceleracion: float = 5.0

# Velocidad actual del escudo
var velocidad_actual: Vector2

# Aguante del escudo
var aguante: int = 15

# Rotación
var vel_rotacion: float = 0.01

# Sprites escudo
var sprite_normal = preload("res://sprites/shield/shield_1.png")
var sprite_dmg_1 = preload("res://sprites/shield/shield_2.png")
var sprite_dmg_2 = preload("res://sprites/shield/shield_3.png")
var sprite_dmg_3 = preload("res://sprites/shield/shield_4.png")
var sprite_dmg_4 = preload("res://sprites/shield/shield_5.png")
var sprite_dmg_5 = preload("res://sprites/shield/shield_6.png")

func _ready() -> void:
	velocidad_actual = velocidad_inicial

# Desplazamiento de proyectil.
func _physics_process(delta: float) -> void:
	rotate(vel_rotacion)
	if velocidad_actual.length() < 1.0:
		velocidad_actual = Vector2.ZERO
		return

	# Aplicar la deceleración al movimiento
	velocidad_actual = velocidad_actual.lerp(Vector2.ZERO, deceleracion * delta)

	# Mover el escudo en función de la velocidad actual
	global_position += velocidad_actual * delta

# Actualiza el sprite en función de la vida restante
func actualizar_sprite():
	var sprite = $Sprite2D

	match aguante:
		15: sprite.texture = sprite_normal
		12: sprite.texture = sprite_dmg_1
		10: sprite.texture = sprite_dmg_2
		8: sprite.texture = sprite_dmg_3
		6: sprite.texture = sprite_dmg_4
		4: sprite.texture = sprite_dmg_5
		
# Colisión con proyectiles
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Proyectiles"):
		aguante -= 1
		actualizar_sprite()
		area.call_deferred("queue_free")
		if aguante <= 0:
			call_deferred("queue_free")
