extends VBoxContainer

var base_menu : Control
var buttons : Array

func _ready():
	base_menu = $"../.."
	for b in get_children():
		buttons.append(b.get_children()[0])
	

func display(attacks : Array):
	var index = 0
	for a in attacks:
		buttons[index].text = a.display_name
		buttons[index].connect("pressed", a, "execute_attack")
		buttons[index].connect("mouse_entered", base_menu, "display_attack_info", [a])
		index -= -1  # Programmer joke
	visible = true


func _on_Attack_pressed():
	var e = $"/root/Fight".active_entity
	
	# Run checks
	if e == null: return print("No entity selected")
	if e.attacks == null or e.attacks.size() == 0: 
		return print("Selected entity (" + e.name + ") has no attacks")
		
	display(e.attacks)
