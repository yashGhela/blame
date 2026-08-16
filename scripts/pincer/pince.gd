extends State
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"



func enter():
	print("Pincing")
	animation_player.play("pince")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().create_timer(3.0).timeout.connect(func(): Transitioned.emit(self,"Wander"))
