extends Control

# Signal called on this object when player has made an action
# i.e. attack, use object or flee
signal action_taken

# AttackMenu path
export(NodePath) var attack_menu

# Current entity
var entity : Entity


""" MAIN METHODS """

func _ready():
	attack_menu = get_node(attack_menu)

func request_action(e : Entity):
	entity = e
	block_input(false)
	attack_menu.attacks = entity.attacks # Feed current entity attacks to the AttackMenu
	
	# Let the rest be handled
	yield(self, "action_taken")
	block_input(true)


""" ATTACKS METHODS """

func display_attack_info(attack : Object):
	if attack.description:
		$AttackStats/Label.text = attack.description
	else:
		$AttackStats/Label.text = "No info available for this attack."


""" WORKING METHODS """

func block_input(cond):
	$InputBlocker.mouse_filter = Control.MOUSE_FILTER_STOP if cond else Control.MOUSE_FILTER_IGNORE

func hide_menus():
	$FightMenu/AttackMenu.visible = false


""" SIGNAL METHODS """

func _on_Button_pressed(index):
	attack_menu.display_attacks()  # Hide attacks
	yield(entity.attacks[index].execute_attack(), "completed")
	emit_signal("action_taken")
