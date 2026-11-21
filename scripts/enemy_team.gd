extends Node


func alert_all():
	for c in get_children():
		if c.is_in_group("Enemy"):
			c.enter_attack_mode();


func dealert_all():
	for c in get_children():
		if c.is_in_group("Enemy"):
			c.enter_patrol_mode();

func _ready() -> void:
	Signalbus.alertTeam.connect(on_alerted)

func on_alerted(caller):
	if caller in get_children():
		alert_all()
