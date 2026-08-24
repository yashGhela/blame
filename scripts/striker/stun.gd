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
	
	
	
	if dist>5.0 and dist<10.0:
		Transitioned.emit(self,"Shoot")
	elif dist<=5.0:
		Transitioned.emit(self, "Distance")
	elif dist>=10.0:
		Transitioned.emit(self,"Idle")
