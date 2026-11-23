extends Node

var enemies:Array = []
#this system lets me nest all enemies regardless of where they aare and if they use a path as children of the team

func _ready() -> void:
	collect_enemies(self)
	Signalbus.alertTeam.connect(on_alerted)
	Signalbus.dealertteam.connect(on_dealerted)

func collect_enemies(node:Node):
	for child in node.get_children():
		print("Checking: ", child.name)


		if child.is_in_group("Enemy"):
			enemies.append(child)

		collect_enemies(child)

func alert_all():
	print("alerting all")
	for e in enemies:
		if is_instance_valid(e):
			e.set_attack_mode()



func dealert_all():
	print("dealerting all")
	for e in enemies:
		if is_instance_valid(e):
			e.set_patrol_mode()
			e.update_patrol_context()


func on_alerted(caller):
	if caller in enemies:
		alert_all()

func on_dealerted(caller):
	if caller in enemies:
		dealert_all()
