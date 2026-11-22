extends CharacterBody3D

var kv:Vector3 = Vector3.ZERO
@export var kd = 12.0
var health:=75
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
var mv:=Vector3.ZERO
var timeshit= 0

@onready var nav_agent: NavigationAgent3D = $navagent

var inv_loc
#location of investigation incident



@onready var stun: Node = $StateMachine/Stun
@onready var patrol_state_machine: Node = $PatrolStateMachine
@onready var attack_state_machine: Node = $AttackStateMachine

@onready var investigate: Node = $PatrolStateMachine/Investigate

@onready var attack: State = $Mode/Attack
@onready var patrol: State = $Mode/Patrol
@onready var mode: Node = $Mode

@export var state_label: Label


#pathing logic 
@export var pathStart:Node3D
@export var path:Path3D
@export var pathFollow:PathFollow3D
#so these are all the elements u need of a path that'll then pass down to patrol pathing logic



func update_target_location(target_location):
	nav_agent.target_position=target_location



func _ready() -> void:
	enter_patrol_mode()
	print("Initial mode: ", mode.current_state.name)

func _process(delta: float) -> void:
	progress_bar.value=health
	state_label.text= mode.current_state.name
	

	if health<=0:
		queue_free()
	
	
	if timeshit>=3 and attack_state_machine.current_state!=stun:
		set_stun()
		timeshit=0

#if a disturbance occurs, the closest enemy must investigate it, this is handled by a world function
func investigate_trigger(loc):
	print("Investigation time")
	inv_loc=loc
	if mode.current_state==patrol:
		patrol_state_machine.current_state = investigate
	

func _physics_process(delta: float) -> void:
	
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


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !body.is_phasing:
		print("hitting player")
		body.health-=10
		

#these functions are for the team monitor to force a change to all the enemies attached
func enter_attack_mode():
	print("ENTER_ATTACK_MODE FUNCTION CALLED")
	if mode.current_state!=attack:
		mode.current_state=attack
	Signalbus.alertTeam.emit(self)

func enter_patrol_mode():
	print("ENTER PATROL MODE CALLED")
	if mode.current_state!=patrol:
		mode.current_state=patrol
	Signalbus.dealertteam.emit(self)

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
