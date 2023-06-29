extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed = 150
var desloc = 0
var gravidade = 3000
var direita=true
onready var sprite = $Sprite
onready var som_dano=$som_dano
onready var drop_asa := preload("res://Ataques/Asa_drop.tscn")
export (int) var hp=5
export (int) var pontos=500

func _ready():
	sprite.play("Direita")
	
func inverte_dir():
	if direita:
		sprite.play("Esquerda")
		get_node( "Sprite_asa" ).set_flip_h( true )
		get_node( "Sprite_asa" ).position.x = 45
		direita=false
	else:
		sprite.play("Direita")
		get_node( "Sprite_asa" ).set_flip_h( false)
		get_node( "Sprite_asa" ).position.x = -45
		direita=true
		
func tomou_dano():
	hp-=1
	som_dano.play()
	if hp==0:
		var asa=drop_asa.instance()
		asa.position=self.global_position
		asa.position.y-=20
		self.get_parent().add_child(asa)
		#print(asa.get_parent())
		#print('inimigo morreu aqui',(self.global_position))
		#print((asa.position))
		som_dano.play()
		get_tree().call_group("HUD", "atualiza_pontos",pontos)
		queue_free()	

func detecta_colisao():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if  collision:
			if collision.collider:
				if collision.collider.is_in_group("Player"):
					get_tree().call_group("Player", "tomou_dano")
					
func _physics_process(delta):
	detecta_colisao()
	velocidade.x =  speed
	velocidade.y += gravidade * delta
	velocidade = move_and_slide(velocidade, Vector2.UP)
	desloc += abs(delta*speed)
	if desloc>=420:
		speed=-speed
		inverte_dir()
		desloc=0
