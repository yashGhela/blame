extends Area3D

var location = global_position
@export var is_interactable:=true


func _input(event):
	if event.is_action_pressed("hit"):
		print("Disruption activated")
		Signalbus.emit_signal("disruption", global_position)
