extends AppWindow
class_name ChatWindow

@export var friendsContainer : Node
@export var container : Node
@export var chatContainer : Node
 
var friend_button
var friend_message
var friend_typing_message
var player_message
var player_response

var friends = {}

func ready():
	# Hide if App is disabled in config
	if not Config.modules_chat:
		button.hide()
		return
	
	load_module()

func load_module():
	friend_button = preload("res://modules/chat/friend_button.tscn")
	friend_message = preload("res://modules/chat/friend_message.tscn")
	friend_typing_message = preload("res://modules/chat/friend_typing_message.tscn")
	player_message = preload("res://modules/chat/player_message.tscn")
	player_response = preload("res://modules/chat/player_response.tscn")

func trigger_content( line : ContentLine ):
	print("Trigger chat line " + line.id)
	# Add new friend
	if not friends.has(line.character_id):
		add_friend(line.get_character())
	
	# Hand of line to friend button
	friends.get(line.character_id).add_line(line)

func add_friend( character : Character ):
	print("Add new friend " + character.character_id)
	# Create new friend button
	var friendButton = friend_button.instantiate()
	friendsContainer.add_child(friendButton)
	
	# Create new message container
	var new = chatContainer.duplicate()
	new.hide()
	container.add_child(new)
	
	# Setup friend button and add to friends
	friendButton.setup(character, new, self)
	friends.set(character.character_id, friendButton)
