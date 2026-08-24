extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !body.is_phasing:
		print("hitting player")
		body.health-=10
		
#func _ready() -> void:
	#get_tree().create_timer(2.0).timeout.connect(func():queue_free())
