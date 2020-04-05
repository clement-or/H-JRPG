tool
extends ProgressBar

export var entity = "../.."

""" MAIN METHODS """

func _ready():
	entity = get_node(entity)

func _process(delta):
	
	if Engine.editor_hint:
		editor_process(delta)
		return


""" EDITOR METHODS """

func editor_process(delta):
	var e
	# Resolve entity if it's still a NodePath
	if entity is String || entity is NodePath:
		if entity == "": return
		e = get_node(entity)
	else:
		e = entity
		
	if e == null: return
	
	# Display entity's AP in ProgressBar
	if e.max_ap != 0:
		max_value = e.max_ap
		value = e.cur_ap
	else:
		max_value = 2
		value = 1

func _get_configuration_warning():
	if !entity:
		return "Entity reference not set"
	return ""


""" WORKING METHODS """

func update_ui(anim = true):
	if entity == null: return
	
	# Do something else if in editor
	if Engine.editor_hint:
		max_value = entity.max_ap
		value = entity.cur_ap
		return
	
	# Get the max value if we haven't got it
	if max_value != entity.max_ap: max_value = entity.max_ap
	
	# Make a Label appear and disappear
	if anim && entity.cur_ap < value: 
		$Anim.play("shake")
		$APLoseLabel.text = String(value - entity.cur_ap)
		$APLoseLabel/Anim.play("lose_points")
	# Tween the value of the bar
	$Tween.interpolate_property(self, "value", value, entity.cur_ap, .5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
func lose_pp(value):
	if value < 0: 
		$PPLoseLabel.text = String(value - entity.cur_ap)
		$PPLoseLabel/Anim.play("lose_points")
