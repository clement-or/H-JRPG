extends Control

func display_attack_info(attack : Object):
	if attack.description:
		$AttackStats/Label.text = attack.description
	else:
		$AttackStats/Label.text = "No info available for this attack."
