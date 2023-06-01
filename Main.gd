extends Node2D

var sceneLimit : Position2D
var porta_castelo : Position2D
var player : KinematicBody2D
var currentScene = null
var area='floresta'
var musica_cast=false

func _ready() -> void:
	currentScene = get_child(0)
	porta_castelo=$Jogo/Porta_castelo
	porta_castelo=$Jogo/Porta_castelo
	sceneLimit = currentScene.get_node("Limite")
	player = currentScene.get_node("Bordas")
	
func _physics_process(delta: float) -> void:
	if player.hp <= 0:
		get_tree().change_scene("res://GameOver.tscn")
		
	if sceneLimit == null:
		return
		
	if player.position.y > sceneLimit.position.y:
		get_tree().change_scene("res://GameOver.tscn")
	
	if player.position.y > porta_castelo.position.y:
		if player.position.x < porta_castelo.position.x:
			area='floresta'
			musica_cast=false
			$musica_castelo.stop()
			
		else:
			area='castelo'
			if not musica_cast:
				musica_cast=true				
				$musica_castelo.play()
		get_tree().call_group("HUD", "mostra_area",area)
		
			#get_tree().change_scene("/root/Main/Inicio")
			#var new_parent = get_node("/root/Main/Inicio")
			#var old_parent=get_node(player.get_parent().get_path())
			#print(old_parent.get_parent().get_child(1).get_path())
			#old_parent.remove_child(player)
			#new_parent.add_child(player)
			#pass
			
			
			#get_tree().change_scene("res://GameOver.tscn")
			#get_tree().change_scene("res://Main/Castelo.tscn")
		
		
func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(0)
	world.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instance()
	sceneLimit = null
	get_tree().get_root().add_child(currentScene)
