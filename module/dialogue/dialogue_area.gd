extends Area2D

@export_file("*json") var scene_text_file
#@export var dialogue_key = ""

var area_active = false
var scene_text = {}


func _ready():
	#background.visible = false
	if scene_text_file != null:
		scene_text = load_scene_text()
	#print(scene_text)
	#SignalBus.connect("display_dialogue", on_display_dialogue)


func _input(event):
	if area_active and event.is_action_pressed("ui_accept"):
		DialogueManager.start_dialog(global_position, scene_text)

func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	if FileAccess.file_exists(scene_text_file):
		return JSON.parse_string(file.get_as_text())
		
func load_scene_text_parent(scene_text_file_parent):
	var file = FileAccess.open(scene_text_file_parent, FileAccess.READ)
	if FileAccess.file_exists(scene_text_file_parent):
		scene_text = JSON.parse_string(file.get_as_text())

func _on_area_entered(_area):
	area_active = true
	print("true")


func _on_area_exited(_area):
	print("false")
	area_active = false
