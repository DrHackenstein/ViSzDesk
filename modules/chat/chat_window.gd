extends AppWindow

@export var friendsContainer : Node
@export var messagesContainerContainer : Node
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
	else:
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
		#print("Loading " + character.character_name)
		load_character(character)

func load_character( character : Character ):
	var friend = friend_button.instantiate()
	friendsContainer.add_child(friend)
	var container = messagesContainer.duplicate()
	messagesContainerContainer.add_child(container)
	friend.setup(character, container)
	
	#TEST
	var msg = friend_message.instantiate()
	msg.text.text = character.character_name + ": HI!"
	container.add_child(msg)

func load_content():
	pass
