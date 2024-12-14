extends Area2D

#Velocidad de proyectil.
const VELOCIDAD = 350

func _ready() -> void:
	pass

# Desplazamiento de proyectil.
func _process(delta: float) -> void:
	position.y += VELOCIDAD * delta

# Colisión.
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Reimu"):
		body.recibir_dmg()
		call_deferred("queue_free")
