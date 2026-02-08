extends AppWindow

@export var empty_container : Node
@export var content_container : Node
@export var avatar : TextureRect
@export var character_name : Label
@export var content : RichTextLabel
@export var delete_button : Button
@export var allow_button : Button

var backlog = []
var current : ContentLine = null

func _ready():
	super._ready()
	
	# Hide if app is disabled in config
	if not Config.modules_moderation:
		button.hide()
		return
	
	# Setup notification beep
	if not Config.modules_mod_beep:
		button.audio = null
	elif not Config.modules_mod_beep_sound == "":
		if Helper.is_supported_audio_format(Config.content_path + Config.modules_mod_beep_sound):
			button.audio.stream = Helper.load_audio_file(Config.content_path + Config.modules_mod_beep_sound)
		else:
			push_warning("Loading Error: Couldn't load chat notification sound " + Config.modules_mod_beep_sound + ". Format not supported!")
	
	# Setup buttons
	allow_button.button_up.connect(handle_allow)
	allow_button.disabled = true
	delete_button.button_up.connect(handle_delete)
	delete_button.disabled = true

func trigger_content( line : ContentLine ):
	if is_override(line):
		backlog.clear()
		reset()
	
	backlog.append(line)
	
	if current == null:
		show_next_post()

		if not is_focused():
			button.increase_notifications()

func show_next_post():
	# Catch empty backlog or already open post
	if backlog.size() == 0 or not current == null:
		return
		
	# Show Post
	current = backlog.pop_front()
	avatar.texture = ImageTexture.create_from_image(current.get_character().character_image)
	character_name.text = current.get_character().character_name
	
	if Config.content_debug:
		content.text = current.id + ": " + current.content + " (Trigger: " + ",".join(current.triggers) +")"
	else:
		content.text = current.content
	
	empty_container.hide()
	content_container.show()
	
	# Enable Buttons
	if not is_inactive():
		allow_button.disabled = false
		delete_button.disabled = false
	
	# Trigger additional content
	if current.triggers.size() > 2:
		for trigger in current.triggers.slice(2,current.triggers.size()):
			if not trigger == null:
				Content.process_content_line(trigger, current.id)

func is_inactive():
	return current.parameters.has("i") or current.parameters.has("in") or current.parameters.has("inactive")

func is_override(line : ContentLine) -> bool:
	return line.parameters.has("o") or line.parameters.has("ovr") or line.parameters.has("ovrd") or line.parameters.has("override")

func handle_allow():
	handle_mod(0)

func handle_delete():
	handle_mod(1)

func handle_mod( moderated : int ):
	# Cache id & trigger
	var id = current.id
	var trigger = null
	if moderated < current.triggers.size():
		trigger = current.triggers.get(moderated)
	
	# Reset everything
	reset()
	
	# Load next backlog item first
	if backlog.size() > 0:
		show_next_post()
	
	# Then process button trigger
	if not trigger == null:
		Content.process_content_line(trigger, id)

func reset():
	current = null
	empty_container.show()
	content_container.hide()
	allow_button.disabled = true
	delete_button.disabled = true

func on_focus_gained():
	super.on_focus_gained()
	button.reset_notifications()
