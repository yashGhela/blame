extends Node3D

@export var target: Node3D
@export var follow_speed := 10.0

func _process(delta):
	if target:
		global_position = global_position.lerp(
			target.global_position,
			follow_speed * delta
		)
