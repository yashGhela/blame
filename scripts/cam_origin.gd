extends Node3D


@export var character:CharacterBody3D

var camera_rotation: Vector2 = Vector2.ZERO
var sens: float = 0.001
var maxy:float= 1.2
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else: 
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion:
		var mouse_event: Vector2 = event.screen_relative * sens
		camera_look(mouse_event)
		

func camera_look(mm:Vector2)->void:
	camera_rotation += mm
	
	transform.basis =Basis()
	character.transform.basis = Basis()
	
	character.rotate_object_local(Vector3(0,1,0), - camera.rotation.x)
	rotate_object_local(Vector3(1,0,0), - camera.rotation.y)
	
	camera.rotation.y = clamp(camera_rotation.y, -maxy, maxy)
	
