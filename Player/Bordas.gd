extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = 1000
export (int) var gravity = 3000
#export (float) var rotation_speed = 1.5
#export (PackedScene) var box : PackedScene

onready var target = position # mesmo que func _ready() ...
onready var sprite = $Sprite
#onready var box := preload("res://Items/Box.tscn")

var velocity = Vector2.ZERO
var rotation_dir = 0

func get_side_input():
	velocity.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")	
	velocity.x *=  speed
	if velocity.x > 0:
		sprite.play("Direita")
	elif velocity.x < 0:
		sprite.play("Esquerda")
	else:
		sprite.stop()
		sprite.frame = 0

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed
		get_tree().call_group("HUD", "updateScore")
		#var b = box.instance()
		#b.position = global_position
		#owner.add_child(b)
	#print(velocity)
		
func _physics_process(delta):
	get_side_input()	
	velocity.y += gravity * delta
	#print(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	#move_and_collide(velocity * delta)
