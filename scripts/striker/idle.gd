extends State

var player:CharacterBody3D
@export var enemy:CharacterBody3D


func enter():
	print("Entered Striker Idle")
	player = get_tree().get_first_node_in_group("Player")
	




func _physics_process(delta: float) -> void:
	var dist = enemy.global_position.distance_to(player.global_position)
	
	if dist<15.0 and dist>5.0:
		Transitioned.emit(self,"Shoot")
	elif dist<5.0:
		Transitioned.emit(self,"Distance")
