extends "res://scripts/Attack.gd"

func _ready():
	pass

func attack():
	var scene = $"/root/Fight"
	if scene:
		var targets = $"/root/Fight/Enemies".get_children()
		for t in targets:
			t.set_cur_ap(t.cur_ap - 10, true)
