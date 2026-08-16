extends CharacterBody3D


var health = 100
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var map: AnimationPlayer = $enemymodel/AnimationPlayer
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var navagent: NavigationAgent3D = $NavigationAgent3D

var player
var kv
@onready var enemymodel: Node3D = $enemymodel

var is_knocked=false
var is_attacking = false

func _ready() -> void:
	progress_bar.value=health

func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")
	progress_bar.value=health
	if health<0:
		queue_free()
	
func _physics_process(delta: float) -> void:
	
	
	
	var player = get_tree().get_first_node_in_group("Player")
	
	var playerdist = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	direction.y=0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	if playerdist<8.0:
		velocity.x = direction.x *3.0
		velocity.z = direction.z *3.0
		
	if playerdist<1:
		is_attacking = true 
		
	if !is_attacking and !is_knocked:
		map.play("rig|walk")
	elif !is_knocked:
		map.play("rig|whack")
	
	if direction != Vector3.ZERO:
		var target_y = atan2(direction.x, direction.z)
		enemymodel.rotation.y = lerp_angle(
		enemymodel.rotation.y,
		target_y,
		8.0 * delta
	)
	if kv:
		velocity=kv
		
	move_and_slide()
	
	
func get_knockback(direction, force,damage):
	health-=damage
	kv =  direction * force
	ap.play("flash")
	is_knocked=true
	map.play("flash")
	await get_tree().create_timer(0.2).timeout
	
	is_knocked=false
	kv=Vector3.ZERO


func _on_hitzone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.health-=10
		print(body.health)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rig|whack":
		is_attacking = false # Replace with function body. # Replace with function body.
