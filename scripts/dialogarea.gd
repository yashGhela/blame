extends CanvasLayer

@export_file("*json") var scene_text_file: String

var scene_text: Dictionary = {}
var selected_text: Array = []
@onready var textspopup: CanvasLayer = $"."
@onready var textmsgportal: ColorRect = $textmsgportal
@onready var scroll_container: ScrollContainer = $textmsgportal/MarginContainer/ScrollContainer
var in_progress: bool = false

@onready var message_container: VBoxContainer = $textmsgportal/MarginContainer/ScrollContainer/message_container
var pending_transition: String = ""
#we are testing changes here
func _ready():
	textmsgportal.visible=false
	scene_text= load_scene_text()
	Signalbus.connect("display_chat",Callable(self, "on_display_chats"))


func load_scene_text():
	if FileAccess.file_exists(scene_text_file):
		var file = FileAccess.open(scene_text_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		return test_json_conv.get_data()
		
func show_text():
	var current_text = selected_text.pop_front()
	
	
	
	
func next_line():
	if selected_text.size() > 0:
		show_text()
		scroll_container.get_v_scroll_bar().value = scroll_container.get_v_scroll_bar().max_value
	

	else:
		finish()

func finish():
	Signalbus.emit_signal("talkingover")
	for child in message_container.get_children():
		child.queue_free()

	textmsgportal.visible = false
	in_progress = false
	
	if pending_transition:
			match pending_transition:
				"level_1":
					get_tree().change_scene_to_file("res://levels/level_1.tscn")
				"main_menu":
					get_tree().change_scene_to_file("res://levels/main_menu.tscn")
				
	
	
	
	
	
		
func on_display_chats(text_key):
	if in_progress:
		next_line()
	else:
		print("This is the text key: ", text_key)
		
		for child in message_container.get_children():
			child.queue_free()

		
		
		textmsgportal.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()
		
		
