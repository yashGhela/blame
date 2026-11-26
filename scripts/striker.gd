extends CharacterBody3D


var kv:Vector3 = Vector3.ZERO
var health:=100
@export var kd = 25.0

var mv:=Vector3.ZERO
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
var timeshit= 0



@onready var nav_agent: NavigationAgent3D = $navagent

var inv_loc
#location of investigation incident

@onready var patrol_context: Node = $PatrolContext


@onready var stun: Node =$AttackStateMachine/Stun
@onready var patrol_state_machine: Node = $PatrolStateMachine
@onready var attack_state_machine: Node = $AttackStateMachine

@onready var investigate: Node = $PatrolStateMachine/Investigate

@onready var attack: State = $Mode/Attack
@onready var patrol: State = $Mode/Patrol
@onready var mode: Node = $Mode


@onready var state_label: Label = $SubViewport/stateLabel

@onready var sub_state_label: Label = $SubViewport/subStateLabel

#pathing logic 
@export var pathStart:Node3D
@export var path:Path3D
@export var pathFollow:PathFollow3D
#so these are all the elements u need of a path that'll then pass down to patrol pathing logic



func update_target_location(target_location):
	nav_agent.target_position=target_location



func _ready() -> void:
	set_patrol_mode()
	print("Initial mode: ", mode.current_state.name)


func _process(delta: float) -> void:
	progress_bar.value=health
	state_label.text= mode.current_state.name
	
	if mode.current_state==patrol:
		sub_state_label.text = patrol_state_machine.current_state.name
	else:
		if attack_state_machine.current_state != null:
			sub_state_label.text = attack_state_machine.current_state.name

	if health<=0:
		queue_free()
	
	
	if timeshit>=3 and attack_state_machine.current_state!=stun:
		set_stun()
		timeshit=0

func investigate_trigger(loc):
	print("Investigation time")
	inv_loc=loc
	if mode.current_state==patrol:
		patrol_state_machine.current_state = investigate
	

func _physics_process(delta: float) -> void:
	
	
	
	var player = get_tree().get_first_node_in_group("Player")
	

	var direction = global_position.direction_to(player.global_position)
	direction.y=0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	rotation.y=0
		
	velocity.x = mv.x + kv.x
	velocity.z = mv.z + kv.z
	
	kv = kv.move_toward(
		Vector3.ZERO,
		kd*delta
	)
	
		
	
	


		
	move_and_slide()
	

#these functions are for the team monitor to force a change to all the enemies attached
func enter_attack_mode():
	print("entering attack mode and allerting team")
	set_attack_mode()
	Signalbus.alertTeam.emit(self)

func set_attack_mode():
	mv=Vector3.ZERO
	if mode.current_state!=attack:
		mode.current_state=attack

func enter_patrol_mode():
	set_patrol_mode()
	Signalbus.dealertteam.emit(self)

func set_player_context():
	patrol_context.set_player_aware()

func set_area_context():
	patrol_context.set_area_aware()
	
func set_patrol_context():
	patrol_context.set_patrol_aware()
	

func set_patrol_mode():
	mv=Vector3.ZERO
	if mode.current_state!=patrol:
		mode.current_state=patrol

func get_knockback(direction, force,damage):
	health-=damage
	kv =  direction.normalized() * (force * 0.4)
	if mode.current_state!=attack:
		enter_attack_mode()
		set_stun()
	#ap.play("flash")
	#await get_tree().create_timer(0.5).timeout
	#kv = Vector3.ZERO
	
func set_stun():
	attack_state_machine.current_state = stun
