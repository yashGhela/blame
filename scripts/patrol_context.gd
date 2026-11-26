extends Node


var states = ["PLAYER_ALERT", "AREA_ALERT","GUARDING_NO_ALERT"]
@export var context_level = states[2];

@export var parent:CharacterBody3D


func _on_patrol_vision_body_entered(body: Node3D) -> void:
	if context_level=="GUARDING_NO_ALERT":
		return
	
	if context_level=="PLAYER_ALERT":
		parent.enter_attack_mode()
	
	if context_level=="AREA_ALERT":
		parent.enter_attack_mode()
		

func set_player_aware():
	context_level=states[0]

func set_area_aware():
	context_level=states[1]

func set_patrol_aware():
	context_level= states[2]
