extends State

@export var this:CharacterBody3D

var is_moving_to_start=false

func enter():
	print("Returning to path start")
	is_moving_to_start=true
