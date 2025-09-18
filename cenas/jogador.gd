extends CharacterBody2D

@export var laser = preload("res://cenas/Laser.tscn")
@onready var ptoLaser = $pontoDoLaser
@onready var timer_disparo = $timerDisparo
@onready var animation_player = $AnimationPlayer

var direction = Vector2()
const SPEED = 100.0
var pode_disparar = true

var start_position: Vector2
var respawn_timer: Timer
var invulneravel = false

func _ready():
	start_position = position
	
	if not is_in_group("tanque"):
		add_to_group("tanque")
		
	respawn_timer = Timer.new()
	respawn_timer.one_shot = true
	respawn_timer.wait_time = 1.2
	add_child(respawn_timer)
	respawn_timer.connect("timeout",Callable(self, "_on_respawn_timeout") )
	
	if animation_player and not animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("shoot") and pode_disparar == true:
		var l = laser.instantiate()
		l.global_position = ptoLaser.global_position
		get_parent().add_child(l)
		pode_disparar = false
		timer_disparo.start()
		$AudioStreamPlayer2D.play()

	move_and_slide()

func _on_timer_disparo_timeout():
	pode_disparar = true 
	
func destruir():
	if invulneravel:
		return

	var main_node = get_tree().get_current_scene()
	if main_node and main_node.has_method("perder_vida"):
		main_node.perder_vida()  

	
	if main_node.vidas > 0:

		invulneravel = true
		collision_layer = 0
		collision_mask = 0
		set_physics_process(false)
		respawn_timer.start()
	else:
		
		invulneravel = true
		collision_layer = 0
		collision_mask = 0
		set_physics_process(false)
		if animation_player:
			animation_player.play("destruido")
		$AudioStreamPlayer2D.play()
		respawn_timer.start()
	
func _on_animation_finished(anim_name):
	if anim_name == "destruido":
		if not animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
			animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
func _on_respawn_timeout():
	if !is_inside_tree():
		return
		
	position  = start_position
	velocity = Vector2.ZERO
	
	collision_layer = 1
	collision_mask = 1
	
	set_physics_process(true)
	
	pode_disparar = true
	
	await get_tree().create_timer(0.6).timeout
	invulneravel = false
	
func eliminado():
	print("eliminado() chamado")
	if !self.is_queued_for_deletion():
		var parent_node = get_parent()
		if parent_node:
			parent_node.remove_child(self)
		queue_free()
