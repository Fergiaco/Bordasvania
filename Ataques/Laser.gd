extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed=900

func _physics_process(delta):
	var colisao = move_and_collide(velocidade*delta*speed)
	if colisao:
		if colisao.collider.is_in_group("Inimigos"):
			colisao.collider.call("tomou_dano")
			print('Laser colidiu')
		self.queue_free()
