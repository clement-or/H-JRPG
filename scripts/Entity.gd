extends Node2D

# Constants
enum GENITALS { P, V, N }
enum GENDERS { M, F, O }

# Excitation points
export var max_ep : int
export var cur_ep : int setget set_cur_ep

# Power points
export var max_pp : int
export var cur_pp : int

export(GENITALS) var genitals
export(GENDERS) var gender

export var display_name : String

# Nodes references
onready var attacks = $Attacks.get_children()
onready var anim = $Anim

## SETTERS/GETTERS ##

func set_cur_ep(value):
	if max_ep != null:
		cur_ep = clamp(value, 0, max_ep)
		return
		
	if value < 0:
		cur_ep = 0
	else:
		cur_ep = value

func set_cur_pp(value):
	if max_pp != null:
		cur_pp = clamp(value, 0, max_pp)
		return
		
	if value < 0:
		cur_pp = 0
	else:
		cur_pp = value
