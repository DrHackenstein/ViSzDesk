extends AppWindow

func ready():
	if %Config.modules_moderation:
		pass
	else:
		button.hide()
		

func trigger_content( line : ContentLine ):
	pass
