extends Node
class_name State

signal Transitioned

func enter():
	pass
	
func exit():
	pass

func update(_delta:float):
	pass

func physics_update(_delta:float):
	pass	



func transition_to(new_state_name):
	Transitioned.emit(self, new_state_name)
