extends State

#this is a reference to the current self
@export var this:CharacterBody3D

var direction:=1.0 
#are you going straight on the path or in reverse?


func enter():
	print(" following  path to patrol")
	
	#if this:
		#var dist_to_start = this.global_position.distance_to(this.pathStart.global_position)
	#
		#if dist_to_start>0.5:
			#transition_to("ReturnToPathStart")

		
	
	

func update(delta: float):

	if !this.path or !this.pathFollow:
		return
	
	

	if this.path.curve.get_baked_length() <= 0:
		return

	if this.pathFollow.progress_ratio > 0.99:
		direction = -1.0

	elif this.pathFollow.progress_ratio <= 0.01:
		direction = 1.0

	this.pathFollow.progress += 3.0 * delta * direction
