extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = 1300
export (int) var gravity = 3000
export (float) var cd_laser = 1.5
export (float) var cd_espada = 1
export (int) var hp = 3
export (float) var cd_inv = 3

onready var audio_laser = $laser
onready var animacao_dano=$animacao_dano
onready var som_dano=$som_dano
onready var target = position 
onready var sprite = $Sprite
onready var Laser := preload("res://Ataques/Laser.tscn")
onready var Espada := preload("res://Ataques/Espada.tscn")
#onready var Asa := preload("res://Ataques/Asa.tscn")
onready var direcao = Vector2(1,0)

var velocity = Vector2.ZERO
var rotation_dir = 0

var pode_atirar=true
var pode_planar=false
var pode_bater=true
var invencivel=false

var timer_laser = Timer.new()
var timer_espada = Timer.new()
var timer_inv =Timer.new()

func _ready() -> void:
	
	timer_laser.set_one_shot(true)
	timer_laser.set_wait_time(cd_laser)
	timer_laser.connect("timeout",self,"pode_atirar")
	add_child(timer_laser)
	
	timer_espada.set_one_shot(true)
	timer_espada.set_wait_time(cd_espada)
	timer_espada.connect("timeout",self,"pode_bater")
	add_child(timer_espada)
	
	timer_inv.set_one_shot(true)
	timer_inv.set_wait_time(cd_inv)
	timer_inv.connect("timeout",self,"stop_inv")
	add_child(timer_inv)
	
func pode_atirar():
	pode_atirar=true
	get_tree().call_group("HUD", "cd_laser",true)
	
func pode_bater():
	pode_bater=true

func get_side_input():
	velocity.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")	
	velocity.x *=  speed
	
	if velocity.x > 0:
		sprite.play("Direita")
		get_node( "Sprite_asa" ).set_flip_h( false )
		get_node( "Sprite_asa" ).position.x = -21.935
		direcao=Vector2(1,0)
		
	elif velocity.x < 0:
		sprite.play("Esquerda")
		get_node( "Sprite_asa" ).set_flip_h( true )
		get_node( "Sprite_asa" ).position.x = 40.873
		direcao=Vector2(-1,0)
		
	else:
		sprite.stop()
		sprite.frame = 0

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed
		
	if Input.is_action_pressed("Projetil") and pode_atirar:
		var l = Laser.instance()	
		#audio_laser.stop()
		l.position = $Posicao_olhos.global_position
		l.velocidade=direcao
		l.add_collision_exception_with(get_node("."))
		owner.get_node("Jogo/Ataques").add_child(l)
		
		pode_atirar=false
		audio_laser.play()
		#mudar chamada 
		get_tree().call_group("HUD", "cd_laser",false)
		timer_laser.start()
		
	if Input.is_action_pressed("Melee") and pode_bater:
		var e = Espada.instance()
		e.position = $Posicao_olhos.global_position
		#e.velocidade=direcao
		e.add_collision_exception_with(get_node("."))
		owner.get_node("Jogo/Ataques").add_child(e)

		pode_bater=false
		timer_espada.start()
		
	if Input.is_action_pressed("Planar") and pode_planar:
		$Sprite_asa.visible=true
		if velocity.y>10:
			gravity=500
		else:
			gravity=3000
	else:
		$Sprite_asa.visible=false
		gravity=3000
	
func tomou_dano():
	if not invencivel:
		invencivel=true
		som_dano.play()
		animacao_dano.play("dano")
		hp-=1
		if hp<0:
			som_dano.play()
			get_tree().change_scene("res://GameOver.tscn")
			
		timer_inv.start()
		get_tree().call_group("HUD", "atualiza_vida",hp)
		
func detecta_colisao():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Inimigos"):
			tomou_dano()
			
		if collision.collider.is_in_group("Itens"):
			print('passou na asa')
			get_tree().call_group("Itens", "coletado")
			pode_planar=true
			
func stop_inv():
	invencivel=false
	animacao_dano.stop()
	som_dano.stop()

func _physics_process(delta):
	get_side_input()	
	velocity.y += gravity * delta
	velocity=move_and_slide(velocity, Vector2.UP)
	detecta_colisao()
	
	
