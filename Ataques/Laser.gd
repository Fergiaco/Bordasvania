extends KinematicBody2D

var velocidade=Vector2(1,0)
export (int) var speed=900
export (int) var alcance=400
var desloc=0

func _physics_process(delta):
	desloc+=speed*delta
	print(desloc)
	if desloc>=alcance:
		self.queue_free()
	var colisao = move_and_collide(velocidade*delta*speed)
	if colisao:
		if colisao.collider.is_in_group("Inimigos"):
			colisao.collider.call("tomou_dano")
			print('Laser colidiu')
		self.queue_free()
