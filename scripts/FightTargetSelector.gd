extends Node

signal selection_done
signal process_done

enum TARGET_TYPES {
	ALLIES,
	ENEMIES,
	ANY
}

var possible_targets : Array
# Selected entity index
var s_index : int
# Selected entity reference
var s_target : Object

var is_selecting = false

func _ready():
	set_process(false)


func _process(delta):
	# Display the selection arrow
	$"../UI/Arrow".global_position.x = s_target.global_position.x
	
	# Change selection on player input
	s_index += int(Input.is_action_just_pressed("ui_left")) - int(Input.is_action_just_pressed("ui_right"))
	s_index = clamp(s_index, 0, possible_targets.size() - 1)
	
	# Get corresponding entity to return it after
	s_target = possible_targets[s_index]
	
	# Exit loop on confirmation
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("process_done")

func select_target(entity):
	if !is_selecting: return
	
	# If the hovered entity is is the array, select it
	if possible_targets.has(entity):
		var i = possible_targets.find(entity)
		s_index = i


func request_target(target_type = TARGET_TYPES.ENEMIES) -> Entity:
	# Safety net
	if target_type < 0 || target_type > TARGET_TYPES.ANY:
		push_error("Specified target_type must be between 0 and 2. Use this TARGET_TYPES enum.")
		return null
	
	# Get stuff
	var scene = get_node("/root/Fight")
	var allies = scene.allies
	var enemies = scene.enemies
	
	# Get which entities the attack can target
	possible_targets = [allies, enemies, allies + enemies][target_type]
	
	# Init stuff
	s_index = 0
	s_target = possible_targets[s_index]
	
	# Do the actual request, resume only when signal is emitted
	is_selecting = true
	set_process(true)
	yield(self, "process_done")
	set_process(false)
	is_selecting = false
	
	scene.set_active_entity(scene.active_entity)
	
	return s_target
