extends State

var player:CharacterBody3D
@export var enemy:CharacterBody3D
@onready var ap: AnimationPlayer = $"../../striker/AnimationPlayer"


func enter():
	print("Entered Striker Idle")
	player = get_tree().get_first_node_in_group("Player")
	ap.play("Cylinder|idle")




func _physics_process(delta: float) -> void:
	var dist = enemy.global_position.distance_to(player.global_position)
	
	if dist<3.0:
		Transitioned.emit(self,"Shoot")
