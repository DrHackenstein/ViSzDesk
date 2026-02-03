extends MarginContainer
class_name ChatMessage

@export var label : RichTextLabel
@export var image : TextureRect
@export var video : VideoPlayer
@export var audio : AudioPlayer

func setup( line : ContentLine ):
	var text = line.content
	
	# Handle loading files
	var start = text.find("[[")
	var end = text.find("]]")
	var filename = ""
	if start > 0 and end > 0:
		filename = text.substr(start + 2, end - start - 2)
		if filename.is_valid_filename() and FileAccess.file_exists(Config.content_path + "/" + filename):
			load_file(filename)
		else:
			push_warning("Couldn't load file \"" + filename + "\" in line " + line.id)
		
		# Remove [[...]] from message
		text = text.substr(0, start) + text.substr(end + 2, -1)
	
	# Set message to display content with or without debug message
	if Config.content_debug:
		label.text = line.id + ": " + text + " (Trigger: " + ",".join(line.triggers) +")"
	else:
		label.text = text
	
	scrolldown()
	
func load_file( filename : String ):
	var file = filename.to_lower()
	if file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".ktx") or file.ends_with(".svg") or file.ends_with(".tga") or file.ends_with(".webp"):
		load_png(filename)
	elif video.supports_format(file):
		load_video(filename)
	elif audio.supports_format(file):
		load_audio(filename)
	else:
		push_warning("Couldn't load " + filename + ": Format not supported!")
	
func load_png( filename : String ):
	var img = Image.load_from_file(Config.content_path + "/" + filename)
	image.texture = ImageTexture.create_from_image(img)
	image.show()

func load_video( filename : String ):
	video.setup(Config.content_path + "/" + filename)
	video.show()

func load_audio( filename : String ):
	audio.setup(Config.content_path + "/" + filename)
	audio.show()
	
func scrolldown():
	await get_tree().process_frame
	await get_tree().process_frame
	var scrollcontainer = get_parent().get_parent()
	var scrollbar = scrollcontainer.get_v_scroll_bar()
	scrollcontainer.scroll_vertical = scrollbar.max_value
