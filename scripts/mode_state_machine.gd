extends "res://scripts/statemachine.gd"

#basically this will extend statemachine code for parent systems

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		if c is State:
			c.ModeTransitioned.connect(on_mode_transitioned)
	
	super._ready()


#this will let us handle changing modes
func on_mode_transitioned(state, new_mode_name):
	if state != current_state:
		return

	var new_mode = states.get(new_mode_name.to_lower())

	if new_mode:
		current_state = new_mode
