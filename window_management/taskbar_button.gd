extends Button

@export var menu : AppWindow

@export var icon_normal : Texture2D
@export var icon_notification : Texture2D
@export var timer : Timer

var normal_style
var hover_style
var focus_style
var blink = false

func _ready():
	if menu:
		menu.button = self
	normal_style = get_theme_stylebox("normal", "Button")
	hover_style = get_theme_stylebox("hover", "Button")
	focus_style = get_theme_stylebox("focus", "Button")
	
	pressed.connect(open_menu)
	
	timer.timeout.connect(blink_button)

func open_menu():
	if( menu.is_visible() ):
		if WindowManager.has_focus(menu):
			menu.hide()
		else:
			menu.grab_focus()
	else:
		menu.show()
	
	release_focus()
	
func focus():
	set_button_style_focused(true)

func unfocus():
	set_button_style_focused(false)

func set_button_style_focused(focused : bool):
	#print(name, " SET BUTTON FOCUS STYLE ", focus)
	if(focused):
		add_theme_stylebox_override("normal", focus_style)
	else:
		remove_theme_stylebox_override("normal")

func notify():
	set_notification(true)

func set_notification(notifyed : bool):
	if notifyed:
		start_blinking()
		set_button_icon(icon_notification)
	else:
		stop_blinking()
		set_button_icon(icon_normal)

func start_blinking():
	blink_button()
	timer.start()
	
func stop_blinking():
	timer.stop()
	blink = true
	blink_button()

func blink_button():
	blink = !blink
	if(blink):
			add_theme_stylebox_override("normal", hover_style)
	elif get_theme_stylebox("normal") == hover_style:
			remove_theme_stylebox_override("normal")
