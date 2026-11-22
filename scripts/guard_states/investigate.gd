extends State

@export var this:CharacterBody3D


func enter():
	print("Entering Investigation Mode")
	
func physics_update(delta:float):
	var location =this.inv_loc
	
	var disttoloc= this.global_position.distance_to(location)
	
	if disttoloc<=2.0:
		this.mv = Vector3.ZERO
		transition_to("Scan")
		return
	
	var dir = this.global_position.direction_to(location)
	
	this.mv =dir*5.0
	
	var look_target=  Vector3(location.x, this.global_position.y, location.z)
	if this.global_position.distance_to(look_target)>0.1:
		this.look_at(look_target,Vector3.UP)
		
