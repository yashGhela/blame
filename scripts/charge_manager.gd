extends Node

@export var maxvalue :=1000
@export var charge:=0

@export var snapno=5
@export var hardmodeval = 650
@export var snapmodeval = 800
@export var explosivemodeval = 950
@export var burnoutmodeval = 1000






var state= "Normal"


func _process(delta: float) -> void:
	if charge >= burnoutmodeval:
		Signalbus.burnoutmode.emit()
		timeout(4)
	elif charge <burnoutmodeval and charge >=explosivemodeval:
		Signalbus.explosivemode.emit()
		timeout(3)
#		triggers normal mode after explosion activated otherwise 

	elif charge <burnoutmodeval and charge >= snapmodeval:
		Signalbus.snapmode.emit()
		timeout(7)
	elif charge < snapmodeval and charge >=hardmodeval:
		Signalbus.hardmode.emit()
		timeout(15)
	else:
		Signalbus.normalmode.emit()

func timeout(time:int):
	get_tree().create_timer(4).timeout.connect(func():
		state="Normal"; 
		charge=200;
		Signalbus.normalmode.emit()
		)


func increase_charge(amount):
	charge+=amount
