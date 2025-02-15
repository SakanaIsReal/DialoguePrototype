extends MarginContainer

@onready var title_label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var text_label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/Text
@onready var timer = $LetterDisplayTimer
@onready var click_animation = $NinePatchRect/Panel/AnimatedSprite2D
@onready var character_sprite = $MarginContainer/MarginContainer/HBoxContainer/Panel/MarginContainer/Sprite2D
@onready var protrait_panel = $MarginContainer/MarginContainer/HBoxContainer/Panel

const MAX_WIDTH = 258
const MAX_TEXT_WIDTH = 160
const MAX_PROTRAIT = 80

var text = "" # The display text, empty because first init
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal  finished_displaying()


func set_character(character_name: String, expression: String = "default"):
	var path = "res://assets/protraits/" + character_name + "/" + expression + ".png"
	
	if ResourceLoader.exists(path):  # Check if the image file exists
		character_sprite.texture = load(path)  # Load the image into the sprite
	else:
		print("Expression not found:", path, "Trying neutral expression...")
		# path = "res://assets/protraits/" + character_name + "/neutral.png"  
		path = "res://assets/protraits/protrait_placeholder.png"  
		
		if ResourceLoader.exists(path):  
			character_sprite.texture = load(path)  # Load "neutral" if expression is missing
		else:
			print("No image found for", character_name)


func display_text(dialogue: Dictionary): # This take JSON content to the function
	#{
		  #"character": "Smolary",
		  #"text": "Where am I?",
		  #"expression": "happy",
		  #"next": "player_response"
	#}
	
	
	set_character(dialogue["character"], dialogue["expression"])
	title_label.text = dialogue["character"] # Take the character name
	text = dialogue["text"]
	text_label.text = dialogue["text"] # Take the dialogue line
	
	
	print(title_label.text,": ", text_label.text)
	
	# This thing is broken, please help me
	# await resized # make sure it resize
	# await get_tree().process_frame # Wait for layout update
	# await get_tree().process_frame # Wait for layout update
	# custom_minimum_size.x = MAX_WIDTH # make sure it fit the max size
	
	print("size.x > MAX_WIDTH: ", size.x > MAX_WIDTH, " x: ", size.x, " MAX: ", MAX_WIDTH)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD 
	# ^ This should be on at any given time, 
	#   it will make sure the text will not exceed the max amount of the box.
	
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#size.x = MAX_WIDTH
		#await resized # wait for x resize
		#await resized # wait for y resize
		#custom_minimum_size.y = size.y
		#await resized
	# Positioning in scenee
	
	size.x = MAX_WIDTH
	
	
	protrait_panel.size.x = MAX_PROTRAIT
	protrait_panel.size.y = MAX_PROTRAIT

	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	printerr(size.x, " |x|")
	
	text_label.text = ""
	visible = true
	
	_display_letter()
	
func _display_letter(): # the typing animation
	text_label.text += text[letter_index] # letter_index start with 0
	
	letter_index += 1 # add index everytime it runs
	if letter_index >= text.length(): # loop until no letter to be loop
		click_animation.visible = true
		finished_displaying.emit() # send the signal for dialogueManager
		return
		
	match text[letter_index]: # this capture the single letter and use the correct time delay
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_letter_display_timer_timeout():
	_display_letter()
