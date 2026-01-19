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
	if is_response():
		add_response()
	else:
		print("Couldn't process chat message " + line.id + ". Unkown parameter: " + line.parameters.get(0) )

func is_message() -> bool:
	return current.parameters.get(0) == "" or "m" or "msg" or "message"

func is_response() -> bool:
	return current.parameters.get(0) == "r" or "rsp" or "response"

func add_message():
	# Handle typing delay
	var wait_time = current.content.split(" ").size() * randf_range(0.25, 0.5)
	var typing = chat.friend_typing_message.instantiate()
	chatContainer.messageContainer.add_child(typing)
	await get_tree().create_timer(wait_time).timeout
	typing.queue_free()
	
	# Add message
	var msg = chat.friend_message.instantiate()
	chatContainer.messageContainer.add_child(msg)
	msg.label.text = current.content
	
	# Handle Triggers
	handle_triggers(current)
	
func add_response():
	var rsp = chat.player_response.instantiate()
	chatContainer.responseContainer.add_child(rsp)
	rsp.setup(current)
	
func add_player_message( line : ContentLine ):
	var msg = chat.player_message.instantiate()
	chatContainer.messageContainer.add_child(msg)
	msg.label.text = line.content
	
	# Handle Triggers
	handle_triggers(line)

func handle_triggers( line : ContentLine ):
	for id in line.triggers:
		%Content.process_content_line(id)
