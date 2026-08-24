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
	
	print("chasing")
	
	var current_location = enemy.global_transform.origin
	var next_location = enemy.navagent.get_next_path_position()
	print(next_location)
	var new_velocity = (next_location-current_location).normalized() * move_speed	
	enemy.mv= new_velocity.move_toward(new_velocity,.25)
	
	var distance = enemy.global_position.distance_to(player.global_position)
	
	if distance > 7.0:
		Transitioned.emit(self, "Idle")
		return
	
	if distance<1.0:
		Transitioned.emit(self,"Attack")
		return
	
	var direction = (player.global_position - enemy.global_position).normalized()
	direction.y = 0
	


	
