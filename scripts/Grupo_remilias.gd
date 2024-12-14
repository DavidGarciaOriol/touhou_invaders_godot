extends Node2D

var remilia = preload("res://scenes/Remilia.tscn")

# Lista de remilias
var lista_remilias = []

func _ready() -> void:

	for i in range(4):

		lista_remilias.append([])

		for j in range(9):
			var remilia_instancia = remilia.instantiate()
			remilia_instancia.global_position = Vector2(140 + 40 * j,40 + 50 * i)
			self.add_child(remilia_instancia)
			
			# Agregamos cada Remilia a la lista
			lista_remilias[i].append(remilia_instancia)
			
			remilia_instancia.connect("remilia_eliminada", Callable(self, "eliminar_remilia"))

func eliminar_remilia(remi:):
	for fila in lista_remilias:
		if remi in fila:
			fila.erase(remi)
			print("Remilia Eliminada")
			print(lista_remilias)

func _process(delta: float) -> void:
	pass
