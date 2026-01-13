extends AppWindow

func ready():
	if %Config.modules_moderation:
		pass
	else:
		button.hide()
