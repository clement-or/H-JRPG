class_name Ally
extends Entity

func _ready():
	pass

func play_turn():
	var scene = $"/root/Fight/UI/Menu".block_input(false)
	yield(self, "attack_finished")
