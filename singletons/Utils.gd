extends Node

func _ready():
	pass

func lose_focus():
	var b = Button.new()
	add_child(b)
	b.grab_focus()
	b.queue_free()

# Solve two bone IK
# @param target_pos The position we want to reach
# @param ik_first The first bone of the chain
# @param ik_second The last bone of the chain
func solve_two_bone_ik(target_pos : Vector2, ik_first : Bone2D, ik_second : Bone2D):
	# Check if we can reach the target
	var min_dist = abs(ik_first.default_length - ik_second.default_length)
	var max_dist = ik_first.default_length + ik_second.default_length
	var dist_to_target = ik_first.position.distance_to(target_pos)
	if (dist_to_target < min_dist || dist_to_target > max_dist):
		push_error("Couldn't reach target point")
		return
	
	var h = dist_to_target
	var d1 = ik_first.default_length
	var d2 = ik_second.default_length
	var x = target_pos.x
	var y = target_pos.y
	
	var t2 = acos((pow(x, 2) + pow(y, 2) - pow(d1, 2) - pow(d2, 2)) / (2*d1*d2))
	var t1 = atan2(y*(d1 + d2 * cos(t2)) - x*(d2 * sin(t2)), x*(d1 + d2*cos(t2)) + y*(d2 * sin(t2)))
	
	return {
		"ik_first_rot": t2,
		"ik_second_rot": t1
	}
