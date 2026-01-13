extends AppWindow

@export var friendsContainer : Node
@export var messagesContainer : Node
@export var responsesContainer : Node
 
var friend_button
var friend_message
var friend_typing_message
var player_message
var player_response

func ready():
	if not %Config.modules_chat:
		button.hide()
		return
	load_module()
	load_characters()
	load_content()

func load_module():
	friend_button = load("res://modules/chat/friend_button.tscn")
	friend_message = load("res://modules/chat/friend_message.tscn")
	friend_typing_message = load("res://modules/chat/friend_typing_message.tscn")
	player_message = load("res://modules/chat/player_message.tscn")
	player_response = load("res://modules/chat/player_response.tscn")
	
func load_characters():
	for character in %Characters.characters:
		print("Loading " + character.character_name)
		var friend = friend_button.instantiate()
		friend.setup(character)
		friendsContainer.add_child(friend)
	
func load_content():
	pass
