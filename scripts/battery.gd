extends Area3D

var status = false


func set_status():
	if status==true:
		return
	else:
		status=true
		start_timer()

func start_timer():
	get_tree().create_timer(3.0).timeout.connect(func():
		status=false
		)
