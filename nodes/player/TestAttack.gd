extends "res://scripts/Attack.gd"

onready var Utils = $"/root/Utils"

func _ready():
	max_damage = 20
	min_damage = 10

func pre_attack():
	var scene = $"/root/Fight"
	if scene:
		var t_selector = $"/root/Fight/TargetSelector"
		Utils.lose_focus()
		
		# Wait for method completion (wait that the target is selected)
		# Yielding function returns GDScriptFunctionState which fires completed signal
		# on completion
		target = yield(t_selector.request_target(t_selector.TARGET_TYPES.ENEMIES), "completed")
