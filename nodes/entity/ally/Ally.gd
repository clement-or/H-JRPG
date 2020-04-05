class_name Ally
extends Entity

export(NodePath) var fighting_menu

func _ready():
	fighting_menu = get_node(fighting_menu)

func play_turn():
	yield(fighting_menu.request_action(self), "completed")
