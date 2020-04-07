tool

class_name Attack, "res://editor/icons/attack.png"
extends Node

signal pre_attack_finished
signal attack_finished
signal play_once_finished

export(String) var display_name
export(String, MULTILINE) var description
export(Array) var tags = []

export(int) var max_damage setget set_max_damage
export(int) var min_damage setget set_min_damage
var damage setget ,get_damage

export(NodePath) var attacker
var target

var conditions = []

export(Animation) var attack_anim
export(Animation) var return_anim

func _ready():
	if attacker:
		attacker = get_node(attacker)

# Handle animation and then attack execution, can be overriden for special behaviour
func execute_attack():
	$"/root/Fight/UI/Menu".block_input(true)
	
	yield(pre_attack(), "completed")
	
	if attacker == null: return
	var anim = attacker.anim
	
	if attack_anim != null:
		play_anim_once(anim, name+"_AttackAnim", attack_anim)
		yield(self, "play_once_finished")
	
	attack()
	target.take_damage(self)
	
	if return_anim != null:
		play_anim_once(anim, name+"_ReturnAnim", return_anim)
		yield(self, "play_once_finished")
	
	anim.play("idle")
	emit_signal("attack_finished")

# Override this to setup attack effects
func attack():
	pass

# This is executed before the attack (request target for example)
func pre_attack():
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

""" SETTERS / GETTERS """

func set_max_damage(value):
	if max_damage <= min_damage:
		max_damage = min_damage
	
func set_min_damage(value):
	if max_damage <= min_damage:
		min_damage = max_damage

func get_damage():
	randomize()
	return floor(rand_range(min_damage, max_damage+1))
