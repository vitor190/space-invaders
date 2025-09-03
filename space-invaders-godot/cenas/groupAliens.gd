extends Node

var Alien = preload("res://cenas/alien.tscn")

@onready var timer_disparar = $TimerDisparo

var lista_aliens = []

func _ready():
	for j in range(4):
		lista_aliens.append([])
		for i in range(8):
			var alien = Alien.instantiate()
			alien.global_position = Vector2(50+20*i, 40+20*j)
			self.add_child(alien)
			lista_aliens[j].append(alien)
			alien.connect("alien_eliminado", Callable(self, "eliminar_alien"))
			alien.connect("alien_eliminado", Callable(get_parent(), "Somar_pontos_alien"))
			
	#print(lista_aliens)
func eliminar_alien(a):
	#print("alien eliminado")
	for fila in lista_aliens:
		for i in range(len(fila)-1):
			if a == fila[i]:
				fila.remove_at(i)
			


func _on_timer_descida_timeout():
	print("descendo")
	for fila in lista_aliens:
		for a in fila:
			if is_instance_valid(a):
				a.position.y += 21


func _on_timer_disparo_timeout():
	var lista_aliens_vivos = []
	for fila in lista_aliens:
		for a in fila:
			if is_instance_valid(a) and !a.is_queued_for_deletion():
				lista_aliens_vivos.append(a)
				
	if lista_aliens_vivos:
		var indice = int(floor(randf_range(0, len(lista_aliens_vivos)-1)))
		lista_aliens_vivos[indice].disparar()
		timer_disparar.wait_time = randf_range(2, 5)
		
