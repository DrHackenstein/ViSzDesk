extends MarginContainer
class_name PlayerResponse

@export var label : RichTextLabel
@export var button : Button

var current : ContentLine
var friendButton : FriendButton

func setup( line : ContentLine, friend : FriendButton ):
	current = line
	friendButton = friend
	
	label.text = current.content
	button.button_up.connect(select_response)
	
func select_response():
	var nodes = get_parent().get_children()
	for node in nodes:
		node.queue_free()
	
	friendButton.add_player_message(current)
