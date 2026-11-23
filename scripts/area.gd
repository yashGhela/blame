extends Node

#this will be an overlord in the tree that controls everything 
#this might need to work by area not world

@onready var player:CharacterBody3D = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	Signalbus.connect("disruption",Callable(self,"on_disruption"))

#if a disruption occurs signal 

func on_disruption(location):
	print(location)
	#print location
	var enemytoinvestigate:CharacterBody3D = get_closest_enemy(location)
	print(enemytoinvestigate)
	enemytoinvestigate.investigate_trigger(location)

#sends location to closest enemy 


func _physics_process(delta: float) -> void:
	if !player:
		return
	get_tree().call_group("Enemy", "update_target_location",player.global_transform.origin)
#we're gonna keep the enemy updated on the players location constantly 

func get_closest_enemy(location:Vector3) -> CharacterBody3D:
	var closest: CharacterBody3D = null
	var closest_distance := INF
	
	for node in get_tree().get_nodes_in_group("Enemy"):
		if not node is CharacterBody3D:
			continue
		var boss = node as CharacterBody3D
		if boss == null:
			continue
		
		var distance := location.distance_squared_to(boss.global_position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest = boss
	
	return closest
