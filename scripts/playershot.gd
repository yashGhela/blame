extends Area3D

@export var player:CharacterBody3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		var kd = global_position.direction_to(body.global_position)
		kd.y=0;
		var kv = 25
		body.get_knockback(kd,kv,20)
		player.charge_manager_inc(30)
		queue_free() 
