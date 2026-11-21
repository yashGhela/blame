extends State

#this handles the attack state machine
@onready var attack_state_machine: Node = $"../../AttackStateMachine"


func enter():
	print("ATTACK MODE ENTERED")
	attack_state_machine.current_state = attack_state_machine.initial_state


func exit():
	attack_state_machine.current_state = null
