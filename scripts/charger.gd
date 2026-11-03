extends StaticBody3D


var charge:=100


func _process(delta: float) -> void:
	if charge<=0:
		queue_free()

func reduce_charge(amt):
	charge-=amt
