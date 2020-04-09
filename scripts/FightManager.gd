extends Node2D

signal turn_ended

onready var allies = $Allies.get_children()
onready var enemies = $Enemies.get_children()

var turn_order

var active_entity : Entity setget set_active_entity

func _ready():
	# Correctly position allies and enemies
	var i = 0
	for ally in allies:
		ally.global_position = $AlliesPos.get_child(3-i).global_position
		i += 1
		
	i = 0
	for enemy in enemies:
		enemy.global_position = $EnemiesPos.get_child(i+enemies.size()).global_position
		i += 1
	
	# Shuffle the turn order, for now it is random
	randomize()
	enemies.shuffle()
	turn_order = allies + enemies
	active_entity = turn_order[0]
	
	# Connect every ally and enemy to the target selector
	for e in allies + enemies:
		e.connect("mouse_entered", $TargetSelector, "select_target")
	
	# Wait for the scene tree to be fully ready
	yield(get_tree(), "idle_frame")
	next_turn()

func next_turn():
	print(active_entity.display_name + "'s turn !")
	
	# Let the entity play its turn
	yield(active_entity.play_turn(), "completed")
	
	# Put first entity on bottom of call stack
	turn_order.push_back(turn_order.pop_front())
	set_active_entity(turn_order[0])
	
	yield(get_tree().create_timer(1), "timeout")
	next_turn()

func victory():
	pass

func defeat():
	pass

func set_active_entity(e : Entity):
	active_entity = e
	$UI/Arrow.global_position.x = active_entity.global_position.x


func _on_Entity_has_died(entity):
	turn_order.erase(entity)
	entity.queue_free()
	yield(entity, "tree_exited")
	
	allies = $Allies.get_children()
	enemies = $Enemies.get_children()
	
	if !enemies.size():
		victory()
		return
	if !allies.size():
		defeat()
		return
