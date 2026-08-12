extends Area3D

@export_file("*.json") var scene_text_file: String
@export var dialog_key := ""
@export var speaker_key := ""

var scene_text: Dictionary = {}
var selected_text: Array = []
var in_progress := false
var active_area := false

@onready var background = $CanvasLayer/bg
@onready var speaker = $CanvasLayer/bg/speaker
@onready var chat = $CanvasLayer/bg/chat


func _ready():
	background.visible = false
	scene_text = load_scene_text()


func _input(event):
	if active_area and event.is_action_pressed("interact"):
		Signalbus.emit_signal("talking")
		if in_progress:
			next_line()
		else:
			start_dialog(dialog_key)


func load_scene_text() -> Dictionary:
	if FileAccess.file_exists(scene_text_file):
		var file = FileAccess.open(scene_text_file, FileAccess.READ)
		var json = JSON.new()
		json.parse(file.get_as_text())
		return json.get_data()

	return {}


func start_dialog(text_key: String):
	if !scene_text.has(text_key):
		push_warning("Dialog key '%s' not found." % text_key)
		return

	background.visible = true
	in_progress = true

	# Get all dialogue for this key
	var dialogue = scene_text[text_key]

	# Only keep dialogue from the selected speaker
	selected_text.clear()

	for entry in dialogue:
		if entry.has("speaker") and entry["speaker"] == speaker_key:
			
			# Add every chat line from that speaker
			for line in entry["chat"]:
				selected_text.append(line)

			break

	if selected_text.is_empty():
		push_warning("No dialogue found for speaker '%s'." % speaker_key)
		finish()
		return

	show_text()


func show_text():
	if selected_text.is_empty():
		finish()
		return

	var text = selected_text.pop_front()

	chat.text = text
	speaker.text = speaker_key


func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()


func finish():
	Signalbus.emit_signal("talkingended")
	chat.text = ""
	speaker.text = ""
	background.visible = false
	in_progress = false


func _on_area_entered(area: Area3D):
	if area.is_in_group("Player"):
		active_area = true


func _on_area_exited(area: Area3D):
	if area.is_in_group("Player"):
		active_area = false
		finish()
