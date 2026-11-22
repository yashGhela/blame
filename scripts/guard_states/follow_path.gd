extends State

#this is a reference to the current self
@export var this:CharacterBody3D

var direction:=1.0 
#are you going straight on the path or in reverse?


func enter():
	print("Pincer following his path to patrol")

func update(delta:float):
	#this if statement accounts for static curves
	if this.path.curve.get_baked_length()>0:
		if this.pathFollow.progress_ratio>0.99:
			direction=-1.0
		elif  this.pathFollow.progress_ratio<=0.01:
			direction=1.0
		
		this.pathFollow.progress+=3.0*delta*direction
	
