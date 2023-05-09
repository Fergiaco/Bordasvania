extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed = 150
var desloc = 0

func inverte_dir():
	if velocidade==Vector2(1,0):
		velocidade = Vector2(-1,0)
	else:
		velocidade=Vector2(1,0)
		
func _physics_process(delta):
	var colision=move_and_collide(velocidade*speed*delta)	
	desloc += delta*speed
	print(desloc)
	if desloc>=500:
		inverte_dir()
		desloc=0
