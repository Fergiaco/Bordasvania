extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = 1000
export (int) var gravity = 3000
export (float) var cd_laser = 1
export (float) var cd_espada = 1

#export (PackedScene) var box : PackedScene

onready var target = position 
onready var sprite = $Sprite
onready var Laser := preload("res://Ataques/Laser.tscn")
onready var Espada := preload("res://Ataques/Espada.tscn")
onready var direcao = Vector2(1,0)

var velocity = Vector2.ZERO
var rotation_dir = 0

var pode_atirar=true
var pode_bater=true
var timer_laser = Timer.new()
var timer_espada = Timer.new()

func _ready() -> void:
	timer_laser.set_one_shot(true)
	timer_laser.set_wait_time(cd_laser)
	timer_laser.connect("timeout",self,"pode_atirar")
	add_child(timer_laser)
	
	timer_espada.set_one_shot(true)
	timer_espada.set_wait_time(cd_espada)
	timer_espada.connect("timeout",self,"pode_bater")
	add_child(timer_espada)
	
func pode_atirar():
	pode_atirar=true
	get_tree().call_group("HUD", "make_visible")
	
func pode_bater():
	pode_bater=true
	
func get_side_input():
	velocity.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")	
	velocity.x *=  speed
	
	if velocity.x > 0:
		sprite.play("Direita")
		direcao=Vector2(1,0)
		
	elif velocity.x < 0:
		sprite.play("Esquerda")
		direcao=Vector2(-1,0)
		
	else:
		sprite.stop()
		sprite.frame = 0

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed
		
	if Input.is_action_pressed("Projetil") and pode_atirar:
		var l = Laser.instance()
		l.position = $Posicao_olhos.global_position
		l.velocidade=direcao
		l.add_collision_exception_with(get_node("."))
		owner.get_node("Castelo/Ataques").add_child(l)
		
		pode_atirar=false
		get_tree().call_group("HUD", "make_invisible")
		timer_laser.start()
		
	if Input.is_action_pressed("Melee") and pode_bater:
		var e = Espada.instance()
		e.position = $Posicao_olhos.global_position
		e.velocidade=direcao
		e.add_collision_exception_with(get_node("."))
		owner.get_node("Castelo/Ataques").add_child(e)
		
		pode_bater=false
		timer_espada.start()
	
func _physics_process(delta):
	get_side_input()	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
