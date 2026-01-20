extends Button
class_name FriendButton

@export var friend_name : Label
@export var friend_pic : TextureRect

var chat : ChatWindow
var chatContainer : Node
var current : ContentLine

func _ready():
	button_down.connect(on_pressed)
	
func on_pressed():	
	# Hide other containers
	for node in chatContainer.get_parent().get_children():
		if node is VBoxContainer:
			node.hide()
	
	# Show this one
	chatContainer.show()

func setup( character : Character, container : Node, chatWindow : ChatWindow ):
	print("Setup friend_button for " + character.character_name)
	friend_name.text = character.character_name
	friend_pic.texture = ImageTexture.create_from_image(character.character_image)
	chatContainer = container
	chat = chatWindow

func add_line( line : ContentLine ):
	current = line
	if is_message():
		add_message()
	elif is_response():
		add_response()
	else:
		print("Couldn't process chat message " + line.id + ". Unkown parameter: " + line.parameters.get(0) )

func is_message() -> bool:
	var p = current.parameters.get(0)
	return p == "" or p == "m" or p == "msg" or p == "message"

func is_response() -> bool:
	var p = current.parameters.get(0)
	return p == "r" or p == "rsp" or p == "response"

func add_message():
	print("Add message " + current.id + " to " + friend_name.text)
	# Handle typing delay
	var wait_time = current.content.split(" ").size() * randf_range(0.25, 0.5)
	var typing = chat.friend_typing_message.instantiate()
	chatContainer.messageContainer.add_child(typing)
	await get_tree().create_timer(wait_time).timeout
	typing.queue_free()
	
	# Add message
	var msg = chat.friend_message.instantiate()
	chatContainer.messageContainer.add_child(msg)
	msg.setup(current.content)
	
	# Handle Triggers
	handle_triggers(current)
	
func add_response():
	print("Add response " + current.id + " to " + friend_name.text)
	var rsp = chat.player_response.instantiate()
	chatContainer.responseContainer.add_child(rsp)
	rsp.setup(current, self)
	
func add_player_message( line : ContentLine ):
	var msg = chat.player_message.instantiate()
	chatContainer.messageContainer.add_child(msg)
	msg.setup(line.content)
	
	# Handle Triggers
	handle_triggers(line)

func handle_triggers( line : ContentLine ):
	for id in line.triggers:
		print("Chat line " + current.id + "(" +friend_name.text+ ") tiggers line " + id)
		Content.process_content_line(id)
