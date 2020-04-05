class_name Enemy
extends Entity

func _ready():
	anim = $Anim

func play_turn():
	$"/root/Fight/UI/Menu".block_input(true)
	yield($EnemyAI.play_turn(), "completed")
