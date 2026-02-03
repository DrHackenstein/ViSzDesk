extends TextureButton

@export var filename : Label

var menu : AppWindow
var taskbar_button : TextureButton

func setup( window : AppWindow, taskbar : TextureButton, title : String ):
	menu = window
	filename.text = title
	taskbar_button = taskbar
	
	if menu:
		menu.button = self
	
	pressed.connect(open_menu)

func open_menu():
	if( menu.is_visible() ):
		menu.grab_focus()
	else:
		taskbar_button.show()
		menu.show()
	
	release_focus()
