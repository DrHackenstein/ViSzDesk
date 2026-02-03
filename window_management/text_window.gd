extends AppWindow

@export var text : RichTextLabel

var taskbar_button : TextureButton

func setup( content : String, taskbar : TextureButton, filename : String ):
	text.text = content
	taskbar_button = taskbar
	title = filename

func hide_dialog():
	taskbar_button.hide()
	hide()
