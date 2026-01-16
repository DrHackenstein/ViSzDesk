extends Button
class_name FriendButton

@export var friend_name : Label
@export var friend_pic : TextureRect

var messageContainer : Node

func _ready():
	button_down.connect(on_pressed)

func setup( character : Character, msgContainer : Node ):
	print("Setup friend_button for " + character.character_name)
	friend_name.text = character.character_name
	friend_pic.texture = ImageTexture.create_from_image(character.character_image)
	messageContainer = msgContainer

func on_pressed():
	
	# Hide other containers
	for node in messageContainer.get_parent().get_children():
		if node is VBoxContainer:
			node.hide()
	
	# Show this one
	messageContainer.show()
	
