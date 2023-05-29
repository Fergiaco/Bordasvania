extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed = 150
var desloc = 0
var gravidade = 3000

onready var sprite = $Sprite
export (int) var hp=3
export (int) var pontos=100

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
		get_tree().call_group("HUD", "atualiza_pontos",pontos)
		queue_free()	
		
func _physics_process(delta):
	var colisao=move_and_collide(velocidade*speed*delta)	
	#velocidade.y=1000
	if colisao:
		if colisao.collider.is_in_group("Player"):
			colisao.collider.call("tomou_dano")
			print(('aaaaa'))
	desloc += delta*speed
	#print(desloc)
	if desloc>=500:
		inverte_dir()
		desloc=0
