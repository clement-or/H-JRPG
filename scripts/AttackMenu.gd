extends VBoxContainer

# Reference to the Label to which display the info
export(NodePath) var attack_display
var attacks : Array

func _ready():
	attack_display = get_node(attack_display)

func display_attacks():
	if !attacks || attacks.size() == 0: return
	
	if visible:
		visible = false
		return
	
	var containers = get_children()
	for i in range(containers.size()):
		var c = containers[i]  # Get current container
		var b = c.get_child(0)  # Get its button
		b.text = attacks[i].display_name
		b.visible = true
	visible = true

# On attack hover, display description
func _on_Button_mouse_entered(index):
	var a = attacks[index]
	
	if a.description && a.description != "":
		attack_display.text = a.description
	else:
		attack_display.text = "No description available for that attack."
