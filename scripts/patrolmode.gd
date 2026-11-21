extends State

#this handles the patrol mode



@onready var patrol_state_machine: Node = $"../../PatrolStateMachine"

@onready var attack_state_machine: Node = $"../../AttackStateMachine"


func enter():
	print("PATROL MODE ENTERED")
	patrol_state_machine.process_mode = Node.PROCESS_MODE_INHERIT
	attack_state_machine.process_mode = Node.PROCESS_MODE_DISABLED

	patrol_state_machine.current_state = patrol_state_machine.initial_state


func exit():
	patrol_state_machine.current_state = null
