extends Window
class_name AppWindow

var button : Button

func _ready() -> void:
	visibility_changed.connect(on_visibility_change)
	close_requested.connect(hide_dialog)
	focus_entered.connect(on_focus_gained)
	focus_exited.connect(on_focus_lost)
	ready()

func ready():
	pass

func hide_dialog():
	hide()

func on_visibility_change():
	if visible:
		print("Visibility Gained: " + name)
		%WindowManager.add(self)
	else:
		print("Visibility Lost: " + name)
		%WindowManager.remove(self)

func on_focus_gained():
	print("Focus Gained: " + name)
	%WindowManager.gain_focus(self)
	
func on_focus_lost():
	print("Focus Lost: " + name)
	#%WindowManager.lose_focus(self)
