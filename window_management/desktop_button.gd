extends Button

@export var menu : AppWindow


func _ready():
	if menu:
		menu.button = self
	
	pressed.connect(open_menu)

func open_menu():
	print("Open: " + name)
	if( menu.is_visible() ):
		if WindowManager.has_focus(menu):
			menu.hide()
		else:
			menu.grab_focus()
	else:
		menu.show()
	
	release_focus()
