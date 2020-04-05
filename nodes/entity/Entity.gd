extends Node2D


""" Constants """
enum GENITALS { P, V, N }
enum GENDERS { M, F, O }

""" Arousal points (HP) """
export var max_ap : int
export var cur_ap : int setget set_cur_ap

""" Power points (PP) """
export var max_pp : int
export var cur_pp : int

""" Exports """
export(GENITALS) var genitals
export(GENDERS) var gender
export(String) var display_name

""" Exported Node references """

# This entity's UI Node
export(NodePath) var entity_ui

""" Nodes references """
# Node having this entity's attacks as children
onready var attacks = $Attacks.get_children()
# This entity's AnimationPlayer
onready var anim = $Anim


func _ready():
	entity_ui = get_node(entity_ui)


""" # SETTERS/GETTERS # """

# Setter for cur_ap property
# @param value Set value
# @param anim Should it be UI animated
func set_cur_ap(value, play_anim=false):
	if max_ap != null:
		cur_ap = clamp(value, 0, max_ap)
	elif value < 0:
		cur_ap = 0
	else:
		cur_ap = value
	
	# Only update if entity_ui has been resolved
	if !typeof(entity_ui) == TYPE_NODE_PATH:
		entity_ui.update_ui(play_anim)

# Setter for cur_pp property
# @param value Set value
# @param anim Should it be UI animated
func set_cur_pp(value, play_anim=false):
	if play_anim:
		var old_pp = cur_pp
		entity_ui.lose_pp(cur_pp + value)
	
	if max_pp != null:
		cur_pp = clamp(value, 0, max_pp)
		return
		
	if value < 0:
		cur_pp = 0
	else:
		cur_pp = value
