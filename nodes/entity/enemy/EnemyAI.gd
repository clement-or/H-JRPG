extends Node

onready var entity = get_parent()

func _ready():
	pass

func play_turn():
	randomize()
	var attack = floor(rand_range(0, entity.attacks.size()))
	attack = entity.attacks[attack]
	attack.execute_attack()
	yield(entity, "attack_finished")
