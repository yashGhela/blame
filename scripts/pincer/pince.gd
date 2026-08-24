extends State
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@export var enemy:CharacterBody3D
var player:CharacterBody3D
var wait_done =false
var has_shot =false

func enter():
	print("Pincing")
	enemy.mv = Vector3.ZERO
	player= get_tree().get_first_node_in_group("Player")
	
	

func _process(delta: float) -> void:
	if !has_shot:
		hit()
	else:
		wait()

func hit():
	animation_player.play("pince")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().create_timer(3.0).timeout.connect(func(): wait())

func wait():
	
	await get_tree().create_timer(2.0).timeout
	
	wait_done = true
	

func physics_update(_delta:float):
	
	var playerdist = enemy.global_position.distance_to(player.global_position)
	if wait_done:
		if playerdist<3.0:
			has_shot=false
		elif playerdist<7.0 and playerdist>3.0:
			Transitioned.emit(self,"Chase")
		elif playerdist>7.0:
			Transitioned.emit(self,"Idle")
