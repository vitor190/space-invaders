extends StaticBody2D

var golpes = 0

@onready var animation_player = $AnimationPlayer

func _ready():
	comprobar_golpes()
   

func destruir():
	golpes += 1
	comprobar_golpes()

func comprobar_golpes():
	if golpes == 0:
		animation_player.play("normal")
	elif golpes == 1:
		animation_player.play("danificado")
	elif golpes == 2:
		queue_free()
