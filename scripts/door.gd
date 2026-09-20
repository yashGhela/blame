extends Node3D
@onready var primitive_wall: MeshInstance3D = $PrimitiveWall


func open():
	var tween = create_tween()
	
	tween.tween_property(primitive_wall,"global_position:y",5.0,1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
