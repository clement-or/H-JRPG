class_name Enemy
extends Entity

func _ready():
	anim = $Anim

func play_turn():
	yield($EnemyAI.play_turn(), "completed")
