extends VBoxContainer

var base_menu : Control
var buttons : Array
var attacks_displayed : Array

func _ready():
	base_menu = $"../.."
	for b in get_children():
		buttons.append(b.get_children()[0])
		b.get_children()[0].connect("pressed", self, "hide_attacks", [attacks_displayed])
	

func display(attacks : Array):
	
	if visible:
		hide_attacks(attacks)
		return
	
	var index = 0
	for a in attacks:
		buttons[index].visible = true
		buttons[index].text = a.display_name
		buttons[index].connect("pressed", a, "execute_attack")
		buttons[index].connect("mouse_entered", base_menu, "display_attack_info", [a])
		index -= -1  # Programmer joke
		
	attacks_displayed = attacks
	visible = true

# TODO : Fix this shit
func hide_attacks(attacks : Array):
	
	var index = 0
	for a in attacks:
		buttons[index].text = "Attack"
		buttons[index].disconnect("pressed", a, "execute_attack")
		buttons[index].disconnect("mouse_entered", base_menu, "display_attack_info")
		buttons[index].visible = false
		index -= -1
		
	attacks_displayed = []
	visible = false

func _on_Attack_pressed():
	var e = $"/root/Fight".active_entity
	
	# Run checks
	if e == null: return print("No entity selected")
	if e.attacks == null or e.attacks.size() == 0: 
		return print("Selected entity (" + e.name + ") has no attacks")
		
	display(e.attacks)


func _on_Fight_turn_ended():
	var e = $"/root/Fight".active_entity
	# Run checks
	if e == null: return print("No entity selected")
	if e.is_in_group("allies"):
		hide_attacks(e.attacks)

