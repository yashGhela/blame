extends CharacterBody3D


var health = 100

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var map: AnimationPlayer = $enemymodel/AnimationPlayer
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var navagent: NavigationAgent3D = $NavigationAgent3D
@onready var enemymodel: Node3D = $enemymodel

@export var kd = 25.0
var timeshit= 0
@onready var state_machine: Node = $StateMachine
@onready var stun: Node = $StateMachine/Stun

var player
var kv: Vector3 = Vector3.ZERO
var mv: Vector3 = Vector3.ZERO

var is_knocked = false
var is_attacking = false


func _ready() -> void:
	progress_bar.value = health


func _process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")

	progress_bar.value = health

	if health <= 0:
		queue_free()
	
	if timeshit>=2 and state_machine.current_state!=stun:
		state_machine.current_state = stun
		timeshit=0


func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement + knockback
	velocity.x = mv.x + kv.x
	velocity.z = mv.z + kv.z

	# Slow down knockback
	kv = kv.move_toward(
		Vector3.ZERO,
		kd * delta
	)

	move_and_slide()


func get_knockback(direction, force, damage):
	health -= damage

	kv = direction * force

	ap.play("flash")

	is_knocked = true

	timeshit+=1

	await get_tree().create_timer(0.2).timeout

	is_knocked = false
	kv = Vector3.ZERO


func _on_hitzone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.health -= 10
		print(body.health)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rig|whack":
		is_attacking = false


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player.health-=10
