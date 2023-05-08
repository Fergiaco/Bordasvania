extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = 1000
export (int) var gravity = 3000
#export (PackedScene) var box : PackedScene

onready var target = position 
onready var sprite = $Sprite
onready var Laser := preload("res://Ataques/Laser.tscn")
onready var direcao = Vector2(1,0)

var velocity = Vector2.ZERO
var rotation_dir = 0

func get_side_input():
	velocity.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")	
	velocity.x *=  speed
	
	if velocity.x > 0:
		sprite.play("Direita")
		#if direcao!=Vector2(1,0):
		direcao=Vector2(1,0)
		
	elif velocity.x < 0:
		sprite.play("Esquerda")
		#if direcao!=Vector2(-1,0):
		direcao=Vector2(-1,0)
		
	else:
		sprite.stop()
		sprite.frame = 0

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed
		get_tree().call_group("HUD", "updateScore")

	if Input.is_action_pressed("Projetil") and pode_atirar():
		var l = Laser.instance()
		l.position = $Posicao_olhos.global_position
		l.velocidade=direcao
		l.add_collision_exception_with(get_node("."))
		owner.add_child(l)
		

func pode_atirar():
	#Implementar timer
	return true
	
func _physics_process(delta):
	get_side_input()	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
