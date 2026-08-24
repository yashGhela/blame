extends State


@export var enemy:CharacterBody3D
var player:CharacterBody3D
var has_attacked = false
@onready var ap: AnimationPlayer = $"../../AnimationPlayer"





func enter():
	print("Attacking")
	enemy.mv = Vector3.ZERO
	

func _process(delta: float) -> void:
	if has_attacked:
		wait()
	else:
		hit()

func hit():
	ap.play("hit")
	has_attacked=true

func wait():
	var dist = enemy.global_position.distance_to(player.global_position)
	
	await get_tree().create_timer(2.0).timeout
	
	if dist<3.0:
		has_attacked=false
	elif dist>3.0 and dist<7.0:
		Transitioned.emit(self,"Chase")
	elif dist>=7.0:
		Transitioned.emit(self,"Idle")
