extends TextureRect

func _ready() -> void:
	var image : Image
	
	# Try to load wallpaper image, if there is none create default image and use that
	if not FileAccess.file_exists(Config.content_path + "/" + Config.content_wallpaper):
		print("Loading Error: Couldn't find wallpaper at " + Config.content_path + "/" + Config.content_wallpaper + ". Created default wallpaper there instead.")
		image = load(Config.content_path_default + "/" + Config.content_wallpaper_default)
		image.save_png(Config.content_path + "/" + Config.content_wallpaper)
	else:
		image = Image.load_from_file(Config.content_path + "/" + Config.content_wallpaper)
	
	texture = ImageTexture.create_from_image(image)
