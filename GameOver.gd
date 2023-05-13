extends Control


func get_input():
	if Input.is_key_pressed(KEY_R):
		get_tree().change_scene("res://Main.tscn")

func _process(delta):
	get_input()
