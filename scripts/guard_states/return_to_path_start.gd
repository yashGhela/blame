extends State

@export var this:CharacterBody3D

var is_moving_to_start=false

func enter():
	print("Returning to path start")
	
	if this.pathStart == null:
		print("No path Start assigned")
		return
	is_moving_to_start=true
	
#this function uses more restricted nav agent movement to return to the start of the path



func physics_update(_delta:float):
	if !is_moving_to_start:
		return
	
	# Get the first point on the path curve
	#var start_point = this.path.curve.get_point_position(0)
	var global_start_point = this.pathStart.global_position
	
	
	this.nav_agent.target_position = global_start_point
	
	var dist_to_loc = this.global_position.distance_to(global_start_point)
	
	# Check if we've reached the start point
	if dist_to_loc < 1.0:  # Increased threshold for better detection
		print("Reached path start")
		this.velocity = Vector3.ZERO
		is_moving_to_start = false
		
		# Reset path follow progress
		if this.pathFollow:
			this.pathFollow.progress = 0
		
		# Transition back to FollowPath state
		transition_to("FollowPath")
		return
	
	# Movement using navigation agent
	if this.nav_agent.is_navigation_finished():
		# If navigation is finished but we're not at target, try setting target again
		this.nav_agent.target_position = global_start_point
	else:
		var next_location = this.nav_agent.get_next_path_position()
		var dir = this.global_position.direction_to(next_location)
		var new_velocity = dir * 3.0
		this.velocity = new_velocity
		
		# Look at the target position (not the start point, but the next navigation point)
		var look_target = Vector3(next_location.x, this.global_position.y, next_location.z)
		if this.global_position.distance_to(look_target) > 0.1:
			this.look_at(look_target, Vector3.UP)
