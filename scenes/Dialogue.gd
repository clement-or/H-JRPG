extends Node2D

signal text_finished_display

export var time_per_char = 0.02

onready var text = $UI/Control/Panel/Text
onready var characters = $UI/Control/Characters

var dialogue = []
var cur_line : Dictionary
var in_scene_characters = []

""" Base Methods """

func _ready():
	# Parse the dialogue file
	var dict = load_and_parse_json("res://resources/dialogues/test.json")
	dialogue = dict.dialogue
	
	# Place the starting characters if applicable
	check_place_characters()

func _input(event):
	if event.is_action_pressed("next_dialogue"):
		# If the text hasn't been fully displayed, speed up
		if $TextTween.is_active():
			$TextTween.stop_all()
			text.text = cur_line.text
			text.percent_visible = 1
		else:
			display_next_dialogue()

""" Helpers """


# Check if the current line asks to rearrange the characters
func check_place_characters():
	if dialogue.size() == 0: return print("End of dialogue")
	
	while dialogue[0].get("characters"):
		var characters = dialogue.pop_front().characters
		characters = get_characters_by_name(characters)
		place_characters(characters)


# Reset the scene by placing only selected characters in array
# @param arr Characters to place in the scene
func place_characters(arr : Array): 
	
	for character in in_scene_characters:
		# If character in scene but not in array, make it quit
		if arr.find(character) == -1:
			character.exit_scene()
	
	in_scene_characters = arr
	
	# If characters in both, do nothing
	# Space out evenly remaining characters
	space_out_characters(in_scene_characters)
	for character in in_scene_characters:
		character.enter_scene()


# Space evenly characters in the scene and tweens to make it look cool
# @param arr Characters to space out evenly
func space_out_characters(arr : Array):
	var i = 1
	for character in arr:
		var new_pos = i * 1920 / (arr.size() + 1)
		character.set_h_pos(new_pos, character.is_in_scene)
		i += 1


# Helper function to select next dialogue and display it correctly
func display_next_dialogue():
	# Check dialogue end
	if dialogue.size() == 0: return print("Dialogue ended")
	
	# If the current line has a "characters" key it means those characters needs to be displayed
	check_place_characters()
	
	# Get current line and current talking character
	cur_line = dialogue.pop_front() # Remove first element
	var cur_char = characters.get_node(cur_line.character)
	
	# If character not found, warning
	if !cur_char: return print("Character " + cur_line.character + " doesn't exist in the dialogue scene")
	
	# If character not in the scene, space out characters and add it
	if in_scene_characters.find(cur_char) == -1:
		var arr = in_scene_characters
		arr.append(cur_char)
		place_characters(arr)
	
	# Typewrite and make character pop in front
	typewrite(cur_line.text)
	cur_char.talk(cur_line.mood)
	
	# Make any other character stop talking
	for c in in_scene_characters:
		if c != cur_char:
			c.stop_talk()


func get_characters_by_name(name_arr : Array):
	var arr = []
	# Construct start_chars array
	for string in name_arr:
		var character = characters.get_node(string)
		if character:
			arr.append(character)
			
	return arr if arr else -1

# Animate text to display it like a typewriter
# @param my_str : The text to display
func typewrite(my_str : String):
	text.text = my_str
	var display_time = time_per_char * my_str.length() # Longer text takes longer to display
	$TextTween.interpolate_property(text, "percent_visible", 0, 1, display_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TextTween.start()
	yield($TextTween, "tween_completed")
	$TextTween.stop_all()


# Load a .json file and parse it into a Dictionary
# @param path The path to the file to parse
# @return The parsed Dictionary
func load_and_parse_json(path : String):
	var dict = {}
	var file = File.new()
	file.open(path, file.READ)
	
	var file_text = file.get_as_text()
	dict = JSON.parse(file_text).result
	file.close()
	return dict
