extends State

#this handles the patrol mode



@onready var patrol_state_machine: Node = $"../../PatrolStateMachine"



func enter():
	patrol_state_machine.current_state = patrol_state_machine.initial_state


func exit():
	patrol_state_machine.current_state = null
