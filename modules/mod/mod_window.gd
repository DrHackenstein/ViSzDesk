extends AppWindow

@export var empty_container : Node
@export var content_container : Node
@export var avatar : TextureRect
@export var content : RichTextLabel
@export var delete_button : Button
@export var allow_button : Button

var current : ContentLine
var trigger
var allowed : bool

func ready():
	if not %Config.modules_moderation:
		button.hide()
		return
	
	delete_button.button_up.connect(handle_delete)
	allow_button.button_up.connect(handle_allow)

func trigger_content( line : ContentLine ):
	current = line
	avatar.texture = ImageTexture.create_from_image(current.get_character().character_image)
	content.text = current.content
	empty_container.hide()
	content_container.show()
	
func handle_allow():
	allowed = true
	handle_mod()

func handle_delete():
	allowed = false
	handle_mod()
	
func handle_mod():
	empty_container.show()
	content_container.hide()
	for i in current.triggers.size():
		if (i == 0 and allowed) or (i == 1 and not allowed) or (i > 1):
			%Content.process_content_line(current.triggers[i])
