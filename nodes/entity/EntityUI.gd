tool
extends ProgressBar


export(NodePath) var entity

""" MAIN METHODS """

func _ready():
	if entity is NodePath:
		entity = get_node(entity)

func _process(delta):
	if Engine.editor_hint:
		editor_process(delta)
		return


""" EDITOR METHODS """

func editor_process(delta):
	var e
	if typeof(entity) == TYPE_NODE_PATH:
		e = get_node(entity)
	else:
		e = entity
		
	if max_value != min_value:
		max_value = e.max_ap
		value = e.cur_ap

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
