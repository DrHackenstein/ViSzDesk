extends MarginContainer
class_name ChatMessage

@export var label : RichTextLabel
@export var image : TextureRect
@export var video : VideoPlayer
@export var audio : AudioPlayer
@export var audio_icon : TextureRect

var line

func setup( content_line : ContentLine ):
	line = content_line
	var text = line.content
	
	# Handle loading files
	var start = text.find("[[")
	var end = text.find("]]")
	var filename = ""
	if start > -1 and end > -1:
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
	if Helper.is_supported_image_format(filename):
		load_image(filename)
	elif Helper.is_supported_video_format(filename):
		load_video(filename)
	elif Helper.is_supported_audio_format(filename):
		load_audio(filename)
	else:
		push_warning("Loading Error: Couldn't load " + filename + ". Format not supported!")
	
func load_image( filename : String ):
	var img = Image.load_from_file(Config.content_path + "/" + filename)
	image.texture = ImageTexture.create_from_image(img)
	image.show()

func load_video( filename : String ):
	video.setup(Config.content_path + "/" + filename)
	video.show()

func load_audio( filename : String ):
	audio.setup(Config.content_path + "/" + filename)
	audio.show()
	audio_icon.texture = ImageTexture.create_from_image(line.get_character().character_image)
	
func scrolldown():
	await get_tree().process_frame
	await get_tree().process_frame
	var scrollcontainer = get_parent().get_parent()
	var scrollbar = scrollcontainer.get_v_scroll_bar()
	scrollcontainer.scroll_vertical = scrollbar.max_value
