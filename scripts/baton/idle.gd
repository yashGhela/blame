extends State

@export var enemy:CharacterBody3D


var move_direction:Vector3
var wander_time:float
var player:CharacterBody3D
@export var move_speed:=0.2

	
func enter():
	print("Entered Idle")
	player= get_tree().get_first_node_in_group("Player")


func physics_update(_delta:float):
	
	var playerdist = enemy.global_position.distance_to(player.global_position)
	if playerdist<7.0:
		Transitioned.emit(self,"Chase")
