extends State

@export var enemy: CharacterBody3D
@export var move_speed := 4.0

var player: CharacterBody3D
var navagent: NavigationAgent3D

@onready var timer: Timer = $"../../Timer"


func enter():
	if not enemy:
		return

	navagent = enemy.get_node("NavigationAgent3D")
	player = get_tree().get_first_node_in_group("Player")

	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

	if not navagent.target_reached.is_connected(_on_target_reached):
		navagent.target_reached.connect(_on_target_reached)

	await get_tree().physics_frame
	await get_tree().physics_frame

	print("NAV MAP: ", navagent.get_navigation_map())

	pick_new_target()


func physics_update(_delta: float):
	if not enemy or not navagent:
		return

	if navagent.is_navigation_finished():
		enemy.mv = Vector3.ZERO
		return

	var npp: Vector3 = navagent.get_next_path_position()

	var dir := enemy.global_position.direction_to(npp)

	# Only move horizontally
	dir.y = 0
	dir = dir.normalized()

	enemy.mv = dir * move_speed

	var playerdist = enemy.global_position.distance_to(
		player.global_position
	)

	if playerdist < 6.0:
		Transitioned.emit(self, "Chase")


func pick_new_target():
	if not navagent:
		return

	var map = navagent.get_navigation_map()

	if map == RID():
		print("NO NAVIGATION MAP!")
		return

	var random_angle = randf() * TAU
	var rand_dist = randf_range(2.0, 5.0)

	var offset = Vector3(
		cos(random_angle),
		0,
		sin(random_angle)
	) * rand_dist

	var target = enemy.global_position + offset
	target.y=1.0
	
	
	var closest_point = NavigationServer3D.map_get_closest_point(
		map,
		target
	)

	print("RANDOM TARGET: ", target)
	print("NAV TARGET: ", closest_point)


	if closest_point!=Vector3.ZERO:
		navagent.target_position= target.global_position


func _on_timer_timeout():
	pick_new_target()


func _on_target_reached():
	pick_new_target()
