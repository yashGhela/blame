extends State


@export var enemy:CharacterBody3D
var player:CharacterBody3D
var has_attacked = false
@onready var ap: AnimationPlayer = $"../../AnimationPlayer"

var dist



func enter():
	print("Attacking")
	enemy.mv = Vector3.ZERO
	player = get_tree().get_first_node_in_group("Player")
	print(player)
	

func _process(delta: float) -> void:
	print(dist)
	if has_attacked:
		wait()
	else:
		hit()

func physics_update(_delta:float):
	dist = enemy.global_position.distance_to(player.global_position)


func hit():
	ap.play("hit")
	has_attacked=true

func wait():
	
	await get_tree().create_timer(2.0).timeout
	
	if dist<2.0:
		has_attacked=false
	elif dist>3.0 and dist<7.0:
		Transitioned.emit(self,"Chase")
	elif dist>=7.0:
		Transitioned.emit(self,"Idle")
