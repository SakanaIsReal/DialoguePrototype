extends CharacterBody2D

@export_file("*json") var scene_text_file
@onready var dialogue_area = $dialogueArea

func _ready():
	dialogue_area.load_scene_text_parent(scene_text_file)
