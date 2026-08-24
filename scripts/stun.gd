extends State

var player:CharacterBody3D
@export var enemy: CharacterBody3D
func enter():
	print("stunned")
	player = get_tree().get_first_node_in_group("Player")
	
	wait()
	

func wait():
	await get_tree().create_timer(3.0).timeout
	
	var dist = enemy.global_position.distance_to(player.global_position)
	
	
	
	if dist>3.0 and dist<7.0:
		Transitioned.emit(self,"Chase")
	elif dist>=7.0:
		Transitioned.emit(self,"Idle")
