extends CharacterBody3D


const SPEED = 9.0
const JUMP_VELOCITY = 4.5

var is_attacking:=false
@onready var health_bar: ProgressBar = $"CanvasLayer/health bar"

var hitcount=1
@onready var body: MeshInstance3D = $body


const DASH_SPEED = 15.0
const DASH_DURATION = 0.3
var is_dashing = false
var dash_timer = 0.0


var health = 100

func _process(delta: float) -> void:
	health_bar.value=health


func _physics_process(delta: float) -> void:
	
	movement(delta)
	move_and_slide()

func movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
		# Handle dash
	if Input.is_action_just_pressed("dash") and not is_dashing:
		is_dashing = true
		dash_timer = DASH_DURATION
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var iso_forward = Vector3(1, 0, 1).normalized()
		var iso_right   = Vector3(1, 0, -1).normalized()
		var direction = (iso_right * input_dir.x + iso_forward * input_dir.y).normalized()
		
		# If no input, dash backward
		if direction == Vector3.ZERO:
			direction = basis.z.normalized()
		#else:
			#direction = -direction  # Dash opposite of movement
		
		velocity.x = direction.x * DASH_SPEED
		velocity.z = direction.z * DASH_SPEED
		
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			# Reset velocity or keep current speed
			velocity.x = 0
			velocity.z = 0
	
	if is_dashing:
		return
	

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var iso_forward = Vector3(1, 0, 1).normalized()
	var iso_right   = Vector3(1, 0, -1).normalized()

	var direction = (iso_right * input_dir.x + iso_forward * input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	
	
		# Don't allow normal movement during dash
	
		
	if direction!=Vector3.ZERO:
			var target_y = atan2(direction.x, direction.z)
			body.rotation.y = lerp_angle(
				body.rotation.y,
				target_y - deg_to_rad(90),
				12.0*delta
			)
