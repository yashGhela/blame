extends CharacterBody3D
@onready var ap: AnimationPlayer = $pincer/AnimationPlayer
var kv:Vector3 = Vector3.ZERO
@export var kd = 25.0
var health:=75
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
var mv:=Vector3.ZERO

func _process(delta: float) -> void:
	progress_bar.value=health
	if health<=0:
		queue_free()


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	velocity.x = mv.x + kv.x
	velocity.z = mv.z + kv.z
	
	kv = kv.move_toward(
		Vector3.ZERO,
		kd*delta
	)
	
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("hitting player")
		body.health-=10
		



func get_knockback(direction, force,damage):
	health-=damage
	kv =  direction.normalized() * force
	ap.play("flash")
	await get_tree().create_timer(0.5).timeout
	kv = Vector3.ZERO
	
