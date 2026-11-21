extends Node
class_name State

signal Transitioned(state, new_state_name)
signal ModeTransitioned(state, new_state_name)

var state_machine #so each state knows which state machine it belongs to

func enter():
	pass
	
func exit():
	pass

func update(_delta:float):
	pass

func physics_update(_delta:float):
	pass	


#handle state transition
func transition_to(new_state_name):
	Transitioned.emit(self, new_state_name)


#handle mode transition [will use this for distances]
func transition_mode(new_mode_name):
	ModeTransitioned.emit(self, new_mode_name)
