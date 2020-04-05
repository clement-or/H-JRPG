extends Node

func _ready():
	pass

func lose_focus():
	var b = Button.new()
	add_child(b)
	b.grab_focus()
	b.queue_free()
