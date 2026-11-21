extends Node


var states = ["PLAYER_ALERT", "AREA_ALERT","GUARDING_NO_ALERT"]
@export var context_level = states[0];


func _on_patrol_vision_body_entered(body: Node3D) -> void:
	if context_level=="GUARDING_NO_ALERT":
		return
	
	if context_level=="PLAYER_ALERT":
		Signalbus.emit("PlayerAlertChase")
	
	if context_level=="AREA_ALERT":
		Signalbus.emit("AreaAlertIdle")
		
