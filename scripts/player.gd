extends CharacterBody3D


var SPEED = 9.0
const JUMP_VELOCITY = 4.5

var is_attacking:=false

@export var hit_pull_distance := 1.0
@export var hit_pull_speed := 8.0
@export var is_phasing:=false

@onready var health_bar: ProgressBar = $"CanvasLayer/health bar"
@onready var body: MeshInstance3D = $body
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D
@onready var basicanims: AnimationPlayer = $basicanims
@onready var hand_1_col: CollisionShape3D = $body/hand1/hand1area/hand1col
@onready var hand_2_col: CollisionShape3D = $body/hand2/hand2area/hand2col
@onready var enemy_detector: Node = $EnemyDetector

const FIRE_RELOAD=1.5
var fire_shots:=6
var is_reloading=false

const DASH_SPEED = 18.0
const DASH_DURATION = 0.3

const SNAP_COOLDOWN=1.5
var snap_cooldown = false


var is_dashing = false
var is_snapping= false

var snap_target: Node3D = null
const SNAP_DISTANCE = 1.5
const SNAP_DURATION = 0.25
var dash_timer = 0.0
var hitcounter = 0

var health = 100


func _ready() -> void:
	Signalbus.connect("talking",Callable(self,"on_talking_activated"))
	Signalbus.connect("talkingended",Callable(self,"on_talking_ended"))

func on_talking_ended():
	var tween = create_tween()
	
	tween.tween_property(camera_3d,"size",8.0,0.7 ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
#Logic to zoom in when talking
func on_talking_activated():
	var tween = create_tween()
	
	tween.tween_property(camera_3d,"size",4.0,0.7 ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _process(delta: float) -> void:
	health_bar.value=health


func _physics_process(delta: float) -> void:
	
	if is_snapping:
		velocity = Vector3.ZERO
		return
	
	
	if Input.is_action_just_pressed("hit"):
		hitcounter+=1
		match hitcounter:
			1:
				basicanims.play("hit_one")
				SPEED=10.0
			2:
				basicanims.play("hit_two")
				SPEED=11.0
			3:
				basicanims.play("hit_three")
				SPEED= 12.0
			
		hand_1_col.disabled=false
		hand_2_col.disabled=false
		
		if hitcounter>3:
			hitcounter=0
	
	if Input.is_action_just_pressed("snap"):
		if is_snapping:
			return
		
		snap()
	
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
		is_phasing=true
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
			is_phasing=false
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

func fire():
	if fire_shots<=0 and not is_reloading:
		return
	
	
	if fire_shots<=0:
		is_reloading=true
		get_tree().create_timer(FIRE_RELOAD).timeout.connect(
			func():
				is_reloading=false
				fire_shots=6
		)

func snap():
	snap_target = enemy_detector.get_furthest_enemy()
	
	if snap_target==null:
		return
	
	is_snapping=true
	snap_cooldown=true
	
	var direction = snap_target.global_position - global_position
	direction.y = 0
	direction = direction.normalized()

	var target_position = snap_target.global_position - direction * SNAP_DISTANCE
	target_position.y = global_position.y

	# Face the enemy
	body.rotation.y = atan2(
		direction.x,
		direction.z
	) - deg_to_rad(90)

	# Move player toward enemy
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"global_position",
		target_position,
		SNAP_DURATION
	)

	await tween.finished

	# Make sure we don't continue if something interrupted the snap
	if not is_snapping:
		return

	velocity = Vector3.ZERO

	# Play attack
	basicanims.play("hit_one")
	
	await get_tree().create_timer(SNAP_COOLDOWN).timeout
	snap_cooldown = false
	
	
	


func enable_hand_1():
	hand_1_col.disabled = false


func disable_hand_1():
	hand_1_col.disabled = true


func enable_hand_2():
	hand_2_col.disabled = false


func disable_hand_2():
	hand_2_col.disabled = true
	


func _on_basicanims_animation_finished(anim_name: StringName) -> void:
	if anim_name=="hit_one" or anim_name=="hit_two" or anim_name=="hit_three":
		hand_1_col.disabled=true
		hand_2_col.disabled=true
		
		if is_snapping:
			is_snapping = false
			snap_target = null
			


func _on_hand_2_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		var kd = global_position.direction_to(body.global_position)
		kd.y=0;
		var kv = 25
		body.get_knockback(kd,kv,20)


func _on_hand_1_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		var kd = global_position.direction_to(body.global_position)
		kd.y=0;
		var kv = 10
		body.get_knockback(kd,kv,20)
