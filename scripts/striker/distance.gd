extends State

@export var enemy:CharacterBody3D
var move_direction:Vector3
var wander_time:float
var player:CharacterBody3D
@export var move_speed:=6.0


func enter():
	print("Entering chase state")
	
	player =get_tree().get_first_node_in_group("Player")



func physics_update(_delta:float):
	
	print("striker distancing")
	

	
	
	var direction = enemy.global_position.direction_to(player.global_position)
	var distance = enemy.global_position.distance_to(player.global_position)
	
	enemy.look_at(enemy.global_position + -direction, Vector3.UP)
	direction.y = 0

	
	
	if distance >= 10.0:
		Transitioned.emit(self, "Idle")
		return
	
	if distance>5.0:
		Transitioned.emit(self,"Shoot")
		return
		
	enemy.mv =-direction*5.0
	
