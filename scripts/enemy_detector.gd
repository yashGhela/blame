extends Node

#this script will detect the closest enemy 

var enemies:Array=[]
var closest_enemy:CharacterBody3D = null
var closest_enemy_distance:=1
@onready var player_combat_system: CharacterBody3D = $".."


func _process(delta: float) -> void:
	Signalbus.connect("enter_flowing",Callable(self,"set_finishers"))
	Signalbus.connect("break_flowing", Callable(self,  "clear_finishers"))
	
	
	
func set_finishers():
	player_combat_system.can_finish=true
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var rand = randi_range(1,2)
		
		if rand==1:
			enemy.is_finish=true
		elif rand==2:
			enemy.is_finish=false
			
			


func clear_finishers():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.is_finish=false
	

func add_next_enemy():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.is_finish==false:
			enemy.is_finish=true
			break


func get_closest_finishable_enemy()-> CharacterBody3D:
	var closest: CharacterBody3D = null
	var closest_distance := INF
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy == null:
			continue
		
		if enemy.is_finish:
			var distance := player_combat_system.global_position.distance_squared_to(enemy.global_position)
		
			if distance < closest_distance:
				closest_distance = distance
				closest = enemy
	
	if closest==null:
		Signalbus.break_flowing.emit()
	return closest
	
	
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
		
		var distance := player_combat_system.global_position.distance_squared_to(enemy.global_position)
		
		if distance > furthest_distance:
			furthest_distance = distance
			furthest = enemy
	
	return furthest
