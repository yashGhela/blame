extends Node

#this script will detect the closest enemy 

var enemies:Array=[]
var closest_enemy:CharacterBody3D = null
var closest_enemy_distance:=1
@onready var player_combat_system: CharacterBody3D = $".."


	
func get_closest_enemy() -> CharacterBody3D:
	var closest: CharacterBody3D = null
	var closest_distance := INF
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy == null:
			continue
		
		var distance := player_combat_system.global_position.distance_squared_to(enemy.global_position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest = enemy
	
	return closest


func get_furthest_enemy() -> CharacterBody3D:
	var furthest: CharacterBody3D = null
	var furthest_distance := -1.0
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy == null:
			continue
		
		if enemy is CharacterBody3D:
			var distance := player_combat_system.global_position.distance_squared_to(enemy.global_position)
		
			if distance > furthest_distance:
				furthest_distance = distance
				furthest = enemy
	
	return furthest
