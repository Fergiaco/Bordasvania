extends CanvasLayer

func _ready():
	transition()
	
func transition():
	$Fade.play("Fade_black")
