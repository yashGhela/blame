extends StaticBody3D

var status = false

@onready var label: Label = $SubViewport/Label



func set_status():
	if status==true:
		return
	else:
		status=true
		label.text="ON"
		start_timer()


func start_timer():
	get_tree().create_timer(4.0).timeout.connect(func():
		status=false
		label.text="OFF"
)
