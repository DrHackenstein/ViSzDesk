extends AppWindow

@export var empty_container : Node
@export var content_container : Node
@export var avatar : TextureRect
@export var content : RichTextLabel
@export var delete_button : Button
@export var allow_button : Button

var backlog = []
var current : ContentLine = null

func ready():
	# Hide if App is disabled in config
	if not Config.modules_moderation:
		button.hide()
		return
	
	# Setup buttons
	allow_button.button_up.connect(handle_allow)
	allow_button.disabled = true
	delete_button.button_up.connect(handle_delete)
	delete_button.disabled = true

func trigger_content( line : ContentLine ):
	backlog.append(line)
	if current == null:
		show_next_post()

func show_next_post():
	# Catch empty backlog or already open post
	if backlog.size() == 0 or not current == null:
		return
		
	# Show Post
	current = backlog.pop_front()
	avatar.texture = ImageTexture.create_from_image(current.get_character().character_image)
	content.text = current.content
	empty_container.hide()
	content_container.show()
	
	# Enable Buttons
	allow_button.disabled = false
	delete_button.disabled = false
	
	# Trigger additional content
	if current.triggers.size() > 2:
		for i in current.triggers.slice(2,-1):
				Content.process_content_line(current.triggers[i])
	
func handle_allow():
	handle_mod(0)

func handle_delete():
	handle_mod(1)

func handle_mod( moderated : int ):
	# Cache triggers
	var trigger = current.triggers.get(moderated)
	
	# Disable everything
	current = null
	empty_container.show()
	content_container.hide()
	allow_button.disabled = true
	delete_button.disabled = true
	
	# Load next backlog item first
	if backlog.size() > 0:
		show_next_post()
	
	# Then process triggers
	Content.process_content_line(trigger)
