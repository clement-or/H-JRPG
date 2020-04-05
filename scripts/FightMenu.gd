extends Control

func display_attack_info(attack : Object):
	if attack.description:
		$AttackStats/Label.text = attack.description
	else:
		$AttackStats/Label.text = "No info available for this attack."

func block_input(cond):
	$InputBlocker.mouse_filter = Control.MOUSE_FILTER_STOP if cond else Control.MOUSE_FILTER_IGNORE

func hide_menus():
	$FightMenu/AttackMenu.visible = false
