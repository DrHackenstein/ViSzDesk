extends AppWindow

@export var text : RichTextLabel

func ready():
	load_credits()

func load_credits():
	# Try to load credits.txt, if there is none create default and use that
	if not FileAccess.file_exists(Config.content_path + "/" + Config.content_textfiles):
		print("Loading Error: Couldn't find credits at " + Config.content_path + "/" + Config.content_textfiles + ". Created default credits there instead.")
		var file = FileAccess.open(Config.content_path + "/" + Config.content_textfiles, FileAccess.WRITE)
		file.store_string(text.text)
		file.close()
	else:
		text.text = FileAccess.open(Config.content_path + "/" + Config.content_textfiles, FileAccess.READ).get_as_text()
