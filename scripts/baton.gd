extends CharacterBody3D


var health = 100

@onready var ap: AnimationPlayer = $AnimationPlayer

@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var navagent: NavigationAgent3D = $NavigationAgent3D


@export var kd = 25.0
var timeshit= 0
@onready var state_machine: Node = $StateMachine
@onready var stun: Node = $StateMachine/Stun

var player
var kv: Vector3 = Vector3.ZERO
var mv: Vector3 = Vector3.ZERO

var is_attacking = false



@onready var nav_agent: NavigationAgent3D = $navagent

var inv_loc
#location of investigation incident



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
@onready var patrol_context: Node = $PatrolContext

func _ready() -> void:
	progress_bar.value = health


func _process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")
	state_label.text= mode.current_state.name
	progress_bar.value = health

	if health <= 0:
		queue_free()
	
	if timeshit>=3 and state_machine.current_state!=stun:
		state_machine.current_state = stun
		timeshit=0


func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	rotation.y=0
	# Movement + knockback
	velocity.x = mv.x + kv.x
	velocity.z = mv.z + kv.z

	# Slow down knockback
	kv = kv.move_toward(
		Vector3.ZERO,
		kd * delta
	)

	move_and_slide()


func investigate_trigger(loc):
	print("Investigation time")
	inv_loc=loc
	if mode.current_state==patrol:
		patrol_state_machine.current_state = investigate
	


func _on_hitzone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !body.is_phasing:
		body.health -= 10
		print(body.health)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rig|whack":
		is_attacking = false


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body.is_in_group("Player"):
		player.health-=10
		
		
#these functions are for the team monitor to force a change to all the enemies attached
func enter_attack_mode():
	set_attack_mode()
	Signalbus.alertTeam.emit(self)

func set_attack_mode():
	mv=Vector3.ZERO
	if mode.current_state!=attack:
		mode.current_state=attack

func enter_patrol_mode():
	set_patrol_mode()
	Signalbus.dealertteam.emit(self)


func set_patrol_mode():
	mv=Vector3.ZERO
	if mode.current_state!=patrol:
		mode.current_state=patrol


func update_patrol_context():
	patrol_context.set_player_aware()
	

func get_knockback(direction, force,damage):
	health-=damage
	kv =  direction.normalized() * (force * 0.4)
	ap.play("flash")
	if mode.current_state!=attack:
		enter_attack_mode()
		set_stun()
	#ap.play("flash")
	#await get_tree().create_timer(0.5).timeout
	#kv = Vector3.ZERO
	
func set_stun():
	attack_state_machine.current_state = stun
