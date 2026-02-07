extends TextureButton

@export var menu : AppWindow
@export var notification_display : Node
@export var notification_counter : Label
var notifications : int

func _ready():
	if menu:
		menu.button = self
	
	pressed.connect(open_menu)

func open_menu():
	if( menu.is_visible() ):
		if WindowManager.has_focus(menu):
			menu.hide()
		else:
			menu.grab_focus()
	else:
		menu.show()
	
	release_focus()

func increase_notifications():
	notifications += 1
	notification_display.show()
	notification_counter.show()
	notification_counter.text = str(notifications)

func decrease_notifications( decrease : int ):
	if notifications <= decrease:
		reset_notifications()
	else:
		notifications -= decrease
		notification_counter.text = str(notifications)

func reset_notifications():
	notifications = 0
	notification_display.hide()
	notification_counter.hide()
