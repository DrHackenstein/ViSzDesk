extends AppWindow

@export var text : RichTextLabel

var taskbar_button : Button

func setup( content : String, taskbar : Button, filename : String ):
	text.text = content
	taskbar_button = taskbar
	title = filename

func hide_dialog():
	taskbar_button.hide()
	hide()
