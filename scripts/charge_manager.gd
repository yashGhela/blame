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

@export var hardmodetime := 8.0
@export var snapmodetime := 6.0
@export var explosivemodetime := 1.0
@export var burnoutmodetime := 4.0

var current_state := ""
var state_id := 0

func _process(delta: float) -> void:
	charge_bar.value = charge

	if charge >= burnoutmodeval:
		set_state("burnt out", Signalbus.burnoutmode, burnoutmodetime)
	elif charge < burnoutmodeval and charge >= explosivemodeval:
		set_state("explosive mode", Signalbus.explosivemode, explosivemodetime)
	elif charge < burnoutmodeval and charge >= snapmodeval:
		set_state("snap mode", Signalbus.snapmode, snapmodetime)
	elif charge < snapmodeval and charge >= hardmodeval:
		set_state("hard mode", Signalbus.hardmode, hardmodetime)
	else:
		set_state("normal mode", Signalbus.normalmode)


func set_state(state_name: String, sig: Signal, time := 0.0) -> void:
	if state_name == current_state:
		return

	current_state = state_name
	state_id += 1
	state_label.text = state_name
	sig.emit()

	if time > 0.0:
		timeout(time)


func timeout(time: float) -> void:
	var my_id := state_id
	await get_tree().create_timer(time).timeout

	if my_id != state_id:
		return

	charge = 0
	Signalbus.normalmode.emit()


func increase_charge(amount):
	charge+=amount
