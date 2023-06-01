extends KinematicBody2D

var velocidade=Vector2(1,0)
var speed=900

func _physics_process(delta):
	var colisao = move_and_collide(velocidade*delta*speed)
	if colisao:
		print(colisao.collider)
		print('Espada colidiu')
		self.queue_free()
