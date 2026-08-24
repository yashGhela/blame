extends State


var player:CharacterBody3D
@export var enemy:CharacterBody3D
@export var bullet:PackedScene
@onready var ap: AnimationPlayer = $"../../striker/AnimationPlayer"
@onready var shoot: AudioStreamPlayer3D = $"../../shoot"

var has_shot = false
var wait_done= false

var bulletinst
func _process(delta: float) -> void:
	if enemy.health<=0:
		if bulletinst:
			bulletinst.queue_free()


func enter():
	print("Entered Shoot")
	enemy.mv = Vector3.ZERO
	player = get_tree().get_first_node_in_group("Player")
	

func hit():
	bulletinst = bullet.instantiate()
	get_tree().current_scene.add_child(bulletinst)
	
	bulletinst.global_position= enemy.global_position
	var tween = create_tween()
	
	
	tween.tween_property(bulletinst,"global_position", player.global_position,1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	has_shot=true
	await tween.finished
	
	
	wait()
	

func wait():
	await get_tree().create_timer(2.0).timeout
	
	wait_done=true


func physics_update(_delta:float):
	var dist = enemy.global_position.distance_to(player.global_position)
	
	if wait_done:
		if dist>10.0:
			Transitioned.emit(self,"Idle")
		elif dist<5.0:
			Transitioned.emit(self,"Distance")
		elif dist>5.0 and dist<10.0:
			has_shot=false
