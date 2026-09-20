extends Area3D

var on = false

@export var required :=0
@export var door=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var count:=0
	while on==false:
		for child in get_children():
			if child.is_in_group("Battery"):
				if child.status==true:
					count+=1
	
	if count>=required:
		on=true
		door.open()
		
	
	
