extends State

var player:CharacterBody3D
@export var enemy:CharacterBody3D


func enter():
	print("Entered Chainer Idle")
	player = get_tree().get_first_node_in_group("Player")
	




func _physics_process(delta: float) -> void:
	var dist = enemy.global_position.distance_to(player.global_position)
	
	if dist<=3.0:
		Transitioned.emit(self,"Whack")
	elif dist <10.0 and enemy.phase==1:
		Transitioned.emit(self,"Grab")
	elif dist <10.0 and enemy.phase==2:
		Transitioned.emit(self,"Slap")
	elif dist <10.0 and enemy.phase==3:
		Transitioned.emit(self,"Slam")
