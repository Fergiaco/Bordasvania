extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed = 150
var desloc = 0
var gravidade = 3000
var direita=true
onready var sprite = $Sprite
export (int) var hp=3
export (int) var pontos=100

func _ready():
	sprite.play("Direita")
	
func inverte_dir():
	if direita:
		sprite.play("Esquerda")
		direita=false
	else:
		sprite.play("Direita")
		direita=true
		
func tomou_dano():
	hp-=1
	if hp==0:
		print("Inimigo morreu")
		get_tree().call_group("HUD", "atualiza_pontos",pontos)
		queue_free()	
		
		
func _physics_process(delta):
	velocidade.x =  speed
	velocidade.y += gravidade * delta
	velocidade = move_and_slide(velocidade, Vector2.UP)
	#var colisao=move_and_collide(velocidade*speed*delta)	
	#velocidade.y=1000
	#if colisao:
	#	if colisao.collider.is_in_group("Player"):
	#		colisao.collider.call("tomou_dano")
	#		print(('aaaaa'))
	desloc += abs(delta*speed)
	print(desloc)
	#print(desloc)
	if desloc>=420:
		speed=-speed
		inverte_dir()
		desloc=0
