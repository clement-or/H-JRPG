extends "res://scripts/Attack.gd"

func _ready():
	max_damage = 20
	min_damage = 20

func pre_attack():
	randomize()
	var allies = $"/root/Fight".allies
	target = allies[floor(rand_range(0, allies.size()))]
	emit_signal("pre_attack_finished")
	yield(get_tree().create_timer(.1), "timeout")
