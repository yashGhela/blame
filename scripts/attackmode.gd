extends State

#this handles the attack state machine
@onready var attack_state_machine: Node = $"../../AttackStateMachine"

@onready var patrol_state_machine: Node = $"../../PatrolStateMachine"


func enter():
	print("ATTACK MODE ENTERED")
	attack_state_machine.process_mode = Node.PROCESS_MODE_INHERIT
	patrol_state_machine.process_mode = Node.PROCESS_MODE_DISABLED
	#disable the other statemachine
	attack_state_machine.current_state = attack_state_machine.initial_state


func exit():
	attack_state_machine.current_state = null
