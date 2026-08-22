extends State

@export var enemy:CharacterBody3D


var move_direction:Vector3
var wander_time:float
var player:CharacterBody3D
@export var move_speed:=0.2
@onready var ap: AnimationPlayer = $"../../pincer/AnimationPlayer"


func randomize_wander():
	move_direction = Vector3(randf_range(-0.5, 0.5), 0, randf_range(-1, 1)).normalized()
	wander_time = randf_range(1,3)
	
	
func enter():
	print("Entered Wander")
	randomize_wander()
	player= get_tree().get_first_node_in_group("Player")


func physics_update(_delta:float):
	if enemy:
		enemy.mv = move_direction* move_speed
	ap.play("Cube|move")
	var playerdist = enemy.global_position.distance_to(player.global_position)
	if playerdist<3.0:
		Transitioned.emit(self,"Pince")
