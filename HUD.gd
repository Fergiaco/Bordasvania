extends CanvasLayer

onready var score=0

func cd_laser(b):
	$Cd_laser.visible=b
	
func atualiza_vida(num):
	$Vidas.text=str(num)

func atualiza_pontos(ponto):
	score+=ponto
	$Score.text="Score: "+str(score)
