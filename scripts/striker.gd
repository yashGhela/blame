extends CharacterBody3D

@onready var striker: Node3D = $striker
var kv:Vector3 = Vector3.ZERO
var health:=100
@export var kd = 25.0
@onready var ap: AnimationPlayer = $striker/AnimationPlayer
var mv:=Vector3.ZERO
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

func _process(delta: float) -> void:
	progress_bar.value=health
	
	if health>100:
		health=100
	if health<=0:
		
		queue_free()

func _physics_process(delta: float) -> void:
	
	
	
	var player = get_tree().get_first_node_in_group("Player")
	

	var direction = global_position.direction_to(player.global_position)
	direction.y=0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
		
	velocity.x = mv.x + kv.x
	velocity.z = mv.z + kv.z
	
	kv = kv.move_toward(
		Vector3.ZERO,
		kd*delta
	)
	
		
	
	


		
	move_and_slide()
	

func get_knockback(direction, force,damage):
	health-=damage
	kv =  direction.normalized() * force
	ap.play("flash")
	
	await get_tree().create_timer(0.2).timeout
	
	kv=Vector3.ZERO
