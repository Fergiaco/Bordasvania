extends ColorRect

onready var rect=get_node(".")

func make_visible():
	print("visi")
	rect.visible=true
	
func make_invisible():
	print("invi")	
	rect.visible=false
