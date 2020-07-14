tool
extends Control

export var neutral_sprite : Texture
export var happy_sprite : Texture
export var angry_sprite : Texture
export var sad_sprite : Texture

onready var anim = $Anim

var is_in_scene = false
var is_talking = false

""" Base methods """

func _ready():
	rect_position.y = 1080

func _process(delta):
	if Engine.editor_hint:
		editor_process()
		return

""" Main methods """

func talk(mood : String):
	# Make talking or appear in scene if it's not
	if !is_in_scene:
		tween_in_scene()
		is_in_scene = true
	if !is_talking:
		anim.play("talk")
		is_talking = true
	
	# Match the expression
	if get(mood+"_sprite"):
		$TextureRect.texture = get(mood+"_sprite")
	else:
		print("Selected mood " + mood + " doesn't exist on specified character")

func stop_talk():
	if is_talking:
		anim.play_backwards("talk")
		is_talking = false

func enter_scene():
	if !is_in_scene:
		tween_in_scene()
		is_in_scene = true

func exit_scene():
	if is_in_scene:
		tween_out_scene()
		is_in_scene = false

""" Helpers """

func tween_in_scene():
	$Tween.interpolate_property(self, "rect_position:y", 1080, 0, .4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func tween_out_scene():
	$Tween.interpolate_property(self, "rect_position:y", 0, 1080, .4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func set_h_pos(pos : float, do_tween : bool = true):
	# Tween
	if do_tween:
		var tween : Tween = $SpaceTween
		tween.interpolate_property(self, "rect_position:x", rect_position.x, pos, .4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else: 
		rect_position.x = pos

""" Editor """


func editor_process():
	if neutral_sprite and (!$TextureRect.texture or $TextureRect.texture != neutral_sprite):
		$TextureRect.texture = neutral_sprite
