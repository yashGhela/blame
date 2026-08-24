extends State


@export var enemy:CharacterBody3D
var player:CharacterBody3D
var has_attacked = false
@onready var ap: AnimationPlayer = $"../../AnimationPlayer"

var dist
var wait_done=false


func enter():
	print("Attacking")
	enemy.mv = Vector3.ZERO
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		push_error("No Player in group 'Player")
		return
	else:
		print("Player found")
	

func _process(delta: float) -> void:
	
	if has_attacked:
		wait()
	else:
		hit()

func physics_update(_delta:float):
	dist = enemy.global_position.distance_to(player.global_position)
	
	if wait_done:
		if dist<2.0:
			has_attacked=false
		elif dist>3.0 and dist<7.0:
			Transitioned.emit(self,"Chase")
		elif dist>=7.0:
			Transitioned.emit(self,"Idle")


func hit():
	ap.play("hit")
	has_attacked=true

func wait():
	
	await get_tree().create_timer(2.0).timeout
	
	wait_done = true
	
