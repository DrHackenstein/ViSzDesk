extends Button
class_name FriendButton

@export var friend_name : Label
@export var friend_pic : TextureRect
@export var bg : Panel
@export var notification_display : Node
@export var notification_counter : Label

var chat : ChatWindow
var chatContainer : ChatContainer
var current : ContentLine
var unread_messages : int

func _ready():
	button_down.connect(on_pressed)
	
func on_pressed():	
	# Hide chat containers
	for node in chatContainer.get_parent().get_children():
		if node is VBoxContainer:
			node.hide()
	
	# Show this chat container
	chatContainer.show()
	
	# Hide backgrounds of friend buttons
	for button in chat.friendsContainer.get_children():
		if button is FriendButton:
			button.bg.hide()
	
	# Show this background
	bg.show()
	
	# Update chat reference
	chat.active_friend = self
	
	# Update Notifications
	reset_notifications()

func setup( character : Character, container : ChatContainer, chatWindow : ChatWindow ):
	print("Setup friend_button for " + character.character_name)
	friend_name.text = character.character_name
	friend_pic.texture = ImageTexture.create_from_image(character.character_image)
	chatContainer = container
	chat = chatWindow

func add_line( line : ContentLine ):
	current = line
	
	# Handle override
	if is_override():
		handle_override()
	
	# Handle empty content
	if current.content == "":
		handle_triggers(current)
		return
	
	if is_message():
		add_message()
	elif is_response():
		add_response()
	else:
		print("Couldn't process chat message " + line.id + ". Unkown parameter: " + line.parameters.get(0) )

func is_message() -> bool:
	return current.parameters.size() == 0 or current.parameters.has("m") or current.parameters.has("msg") or current.parameters.has("message")

func is_response() -> bool:
	return current.parameters.has("r") or current.parameters.has("rsp") or current.parameters.has("response")

func is_override() -> bool:
	return current.parameters.has("o") or current.parameters.has("ovr") or current.parameters.has("ovrd") or current.parameters.has("override")

func handle_override():
	if is_message():
		var messages = chatContainer.messageContainer.get_children()
		for msg in messages:
			msg.queue_free()
	elif is_response():
		var responses = chatContainer.responseContainer.get_children()
		for rsp in responses:
			rsp.queue_free()

func add_message():
	print("Add message " + current.id + " to " + friend_name.text)
	
	# Handle typing delay
	if not Config.content_debug:
		var wait_time = current.content.split(" ").size() * randf_range(0.25, 0.5)
		var typing = chat.friend_typing_message.instantiate()
		chatContainer.messageContainer.add_child(typing)
		await get_tree().create_timer(wait_time).timeout
		typing.queue_free()
	
	# Add message
	var msg = chat.friend_message.instantiate()
	chatContainer.messageContainer.add_child(msg)
	msg.setup(current)
	
	# Handle Notification
	if not chat.is_focused() or not chat.active_friend == self:
		increase_notifications()
	
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
	msg.setup(line)
	
	# Handle Triggers
	handle_triggers(line)

func handle_triggers( line : ContentLine ):
	for id in line.triggers:
		if not id == null:
			print("Chat line " + current.id + "(" +friend_name.text+ ") tiggers line " + id)
			Content.process_content_line(id, line.id)

func increase_notifications():
	# Update Taskbar button
	chat.button.increase_notifications()
	
	# Update own notification display
	unread_messages += 1
	notification_display.show()
	notification_counter.show()
	notification_counter.text = str(unread_messages)

func reset_notifications():
	# Update Taskbar button
	chat.button.decrease_notifications(unread_messages)
	
	# Reset own notification display
	unread_messages = 0
	notification_display.hide()
	notification_counter.hide()
