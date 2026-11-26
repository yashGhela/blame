extends State

var player:CharacterBody3D
@export var enemy: CharacterBody3D
func enter():
	
	player = get_tree().get_first_node_in_group("Player")
	
	wait()
	

func wait():
	await get_tree().create_timer(2.0).timeout
	
	var dist = enemy.global_position.distance_to(player.global_position)
	
	
	
	if dist>3.0 and dist<10.0:
		transition_to("Chase")
	elif dist>=10.0:
		transition_to("Idle")
	elif dist>20.0:
		enemy.enter_patrol_mode()
		return
