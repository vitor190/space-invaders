extends Node

var pontos = 0
var vidas = 3
var tempo_maximo = 30.0
var tempo_restante = 30.0

@onready var label_pontos = $VBoxContainer/LabelPontos
@onready var label_vidas = $VBoxContainer/LabelVidas
@onready var label_tempo = $VBoxContainer/LabelTempo

@onready var timer_limite = Timer.new()

func _ready():
	tempo_restante = tempo_maximo
	_update_labels()
	label_tempo.text = str(int(tempo_restante))

	
	timer_limite.one_shot = true
	timer_limite.wait_time = tempo_maximo
	add_child(timer_limite)
	timer_limite.connect("timeout", Callable(self, "_on_tempo_esgotado"))
	timer_limite.start()


func _process(delta):
	
	if tempo_restante > 0:
		tempo_restante -= delta
		if tempo_restante < 0:
			tempo_restante = 0
		label_tempo.text = str(int(tempo_restante))

# Pontos
func Somar_pontos_alien():
	pontos += 100
	_update_labels()
	_check_vitoria()


func somar_bonus():
	pontos += 500
	_update_labels()

# Vidas
func perder_vida():
	vidas -= 1
	_update_labels()

	if vidas <= 0:
		get_tree().change_scene_to_file("res://cenas/game_over.tscn")

func _update_labels():
	label_pontos.text = "Pontos: " + str(pontos)
	label_vidas.text = "Vidas: " + str(vidas)


func _on_tempo_esgotado():
	var aliens_vivos = get_tree().get_nodes_in_group("aliens")
	if aliens_vivos.size() > 0:
		
		get_tree().change_scene_to_file("res://cenas/game_over.tscn")


func _check_vitoria():
	var aliens_vivos = get_tree().get_nodes_in_group("aliens")
	if aliens_vivos.size() == 0:
		
		timer_limite.stop()
		label_tempo.text = "00"
		
