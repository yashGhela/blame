extends State


var player:CharacterBody3D
@export var enemy:CharacterBody3D
@export var bullet:PackedScene
@onready var ap: AnimationPlayer = $"../../striker/AnimationPlayer"
@onready var shoot: AudioStreamPlayer3D = $"../../shoot"

var bulletinst
func _process(delta: float) -> void:
	if enemy.health<=0:
		bulletinst.queue_free()
func enter():
	print("Entered Shoot")
	
	bulletinst = bullet.instantiate()
	get_tree().current_scene.add_child(bulletinst)
	player = get_tree().get_first_node_in_group("Player")
	bulletinst.global_position= enemy.global_position
	var tween = create_tween()
	
	
	tween.tween_property(bulletinst,"global_position", player.global_position,1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	get_tree().create_timer(2.0).timeout.connect(func():Transitioned.emit(self,"Idle"))
