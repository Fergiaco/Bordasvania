extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed = 150
var desloc = 0
onready var sprite = $Sprite
export (int) var hp=3

func _ready():
	sprite.play("Direita")
	
func inverte_dir():
	if velocidade==Vector2(1,0):
		velocidade = Vector2(-1,0)
		sprite.play("Esquerda")
	else:
		velocidade=Vector2(1,0)
		sprite.play("Direita")
		
func tomou_dano():
	hp-=1
	if hp==0:
		print("Inimigo morreu")
		queue_free()	
		
func _physics_process(delta):
	var colision=move_and_collide(velocidade*speed*delta)	
	desloc += delta*speed
	#print(desloc)
	if desloc>=500:
		inverte_dir()
		desloc=0
