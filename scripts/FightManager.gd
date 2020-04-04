extends Node2D

onready var allies = $Allies.get_children()
onready var enemies = $Enemies.get_children()

onready var active_entity = allies[0] setget set_active_entity

func _ready():
	set_active_entity(active_entity)

func set_active_entity(e):
	if active_entity != null:
		active_entity = e
		$UI/Arrow.global_position.x = active_entity.global_position.x
