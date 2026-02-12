extends AppWindow
class_name ChatWindow

@export var friendsContainer : Node
@export var container : Node
@export var chatContainer : ChatContainer
 
var friend_button
var friend_message
var friend_typing_message
var player_message
var player_response

var friends = {}
var active_friend : FriendButton

func _ready():
	super._ready()
	
	# Set Window Name
	title = Config.modules_chat_name
	
	# Hide if App is disabled in config
	if not Config.modules_chat:
		button.hide()
		return
	
	# Setup notification beep
	if not Config.modules_chat_beep:
		button.audio = null
	elif not Config.modules_chat_beep_sound == "":
		if Helper.is_supported_audio_format(Config.content_path + "/" + Config.modules_chat_beep_sound):
			button.audio.stream = Helper.load_audio_file(Config.content_path + "/" + Config.modules_chat_beep_sound)
		else:
			push_warning("Loading Error: Couldn't load chat notification sound " + Config.modules_chat_beep_sound + ". Format not supported!")
	
	load_module()

func load_module():
	friend_button = preload("res://modules/chat/friend_button.tscn")
	friend_message = preload("res://modules/chat/friend_message.tscn")
	friend_typing_message = preload("res://modules/chat/friend_typing_message.tscn")
	player_message = preload("res://modules/chat/player_message.tscn")
	player_response = preload("res://modules/chat/player_response.tscn")

func trigger_content( line : ContentLine ):
	# Add new friend
	if not friends.has(line.character_id):
		add_friend(line.get_character())
	
	# Hand over line to friend button
	friends.get(line.character_id).add_line(line)

func add_friend( character : Character ):
	# Create new friend button
	var friendButton = friend_button.instantiate()
	friendsContainer.add_child(friendButton)
	
	# Create new message container
	var new = chatContainer.duplicate()
	new.setup(character)
	new.hide()
	container.add_child(new)
	
	# Setup friend button and add to friends
	friendButton.setup(character, new, self)
	friends.set(character.character_id, friendButton)
	
	# Show first friend chat added
	if friends.size() == 1:
		friendButton.on_pressed()

func on_focus_gained():
	super.on_focus_gained()
	if not active_friend == null:
		active_friend.reset_notifications()
