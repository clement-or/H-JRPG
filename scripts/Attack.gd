extends Node

signal finished
signal play_once_finished

export(String) var display_name
export(String, MULTILINE) var description

export(NodePath) var attacker
var target
export(PoolStringArray) var tags

var conditions = []

export(Animation) var attack_anim
export(Animation) var return_anim

func _ready():
	assert(attacker)
	attacker = get_node(attacker)

# Handle animation and then attack execution, can be overriden for special behaviour
func execute_attack():
	if attacker == null: return
	var anim = attacker.anim
	
	if attack_anim != null:
		play_anim_once(anim, name+"_AttackAnim", attack_anim)
		yield(self, "play_once_finished")
	
	attack()
	
	if return_anim != null:
		play_anim_once(anim, name+"_ReturnAnim", return_anim)
		yield(self, "play_once_finished")
	
	anim.play("idle")
	
	emit_signal("finished")

# Override this to setup attack effects
func attack():
	pass

# Play animation once on targeted AnimationPlayer
# @param anim_player AnimationPlayer on which to play the animation
# @param anim_name Temporary animation name, make sure it isn't already taken
# @param anim The actual Animation resource
func play_anim_once(anim_player : AnimationPlayer, anim_name : String, anim : Animation):
	anim_player.add_animation(name+"_AttackAnim", attack_anim)
	anim_player.play(name+"_AttackAnim")
	yield(anim_player, "animation_finished")
	anim_player.remove_animation(name+"_AttackAnim")
	emit_signal("play_once_finished")

func check_conditions():
	var r_value = true
	for cond in conditions:
		cond = cond && r_value
	return r_value
