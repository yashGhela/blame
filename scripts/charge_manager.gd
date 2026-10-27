extends Node

@export var maxvalue :=1000
@export var charge:=0

@export var snapno=5
@export var hardmodeval = 450
@export var snapmodeval = 700
@export var explosivemodeval = 950
@export var burnoutmodeval = 1000

@onready var charge_bar: ProgressBar = $"../CanvasLayer/ChargeBar"
@onready var state_label: Label = $"../CanvasLayer/StateLabel"




func _process(delta: float) -> void:
	
	charge_bar.value= charge
	if charge >= burnoutmodeval:
		Signalbus.burnoutmode.emit()
		timeout(4)
		state_label.text="burnt out"
	elif charge <burnoutmodeval and charge >=explosivemodeval:
		Signalbus.explosivemode.emit()
		timeout(3)
		state_label.text="explosive mode"
#		triggers normal mode after explosion activated otherwise 

	elif charge <burnoutmodeval and charge >= snapmodeval:
		Signalbus.snapmode.emit()
		
		state_label.text="snap mode"
	elif charge < snapmodeval and charge >=hardmodeval:
		Signalbus.hardmode.emit()
		
		state_label.text="hard mode"
	else:
		Signalbus.normalmode.emit()
		state_label.text="normal mode"

func timeout(time:int):
	get_tree().create_timer(4).timeout.connect(func():
		
		charge=200;
		state_label.text="normal mode"
		Signalbus.normalmode.emit()
		)


func increase_charge(amount):
	charge+=amount
