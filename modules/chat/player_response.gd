extends MarginContainer
class_name PlayerResponse

@export var label : RichTextLabel
@export var button : Button

var current : ContentLine
var friendButton : FriendButton

func setup( line : ContentLine, friend : FriendButton ):
	current = line
	friendButton = friend
	
	if Config.content_debug:
		label.text = line.id + ": " + line.content + " (Trigger: " + ",".join(line.triggers) +")"
	else:
		label.text = line.content
	
	button.button_up.connect(select_response)
	
func select_response():
	# Clear alternative responses with same parent
	var nodes = get_parent().get_children()
	for node in nodes:
		if not node.current == null and node.current.parent == current.parent:
			node.queue_free()
	
	friendButton.add_player_message(current)
