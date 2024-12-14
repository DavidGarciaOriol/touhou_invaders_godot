extends Area2D

#Velocidad de proyectil.
const VELOCIDAD = 500

func _ready() -> void:
	pass

# Desplazamiento de proyectil.
func _process(delta: float) -> void:
	position.y -= VELOCIDAD * delta

# Colisión.
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Remilia"):
		body.morir()
		call_deferred("queue_free")
