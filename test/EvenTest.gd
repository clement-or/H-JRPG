tool
extends Node2D

func _process(delta):
	var children : Array = get_children()
	var i = 0
	for child in children:
		child.global_position.x = (i+1) * 1920/(children.size() + 1)
		i -= -1
