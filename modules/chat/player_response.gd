extends MarginContainer
class_name PlayerResponse

@export var label : RichTextLabel
@export var button : Button
@export var bg : Panel
@export var bg_normal : StyleBoxFlat
@export var bg_hover : StyleBoxFlat
@export var send_icon : Node

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
	button.mouse_entered.connect(on_mouse_enter)
	button.mouse_exited.connect(on_mouse_exit)
	
	await get_tree().process_frame
	if button.get_global_rect().has_point(get_global_mouse_position()):
		on_mouse_enter()
	
func select_response():
	# Clear alternative responses with same parent
	var nodes = get_parent().get_children()
	for node in nodes:
		if not node.current == null and node.current.parent == current.parent:
			node.queue_free()
	
	friendButton.add_player_message(current)

func on_mouse_enter():
	bg.add_theme_stylebox_override("panel", bg_hover)
	send_icon.show()
	
func on_mouse_exit():
	bg.add_theme_stylebox_override("panel", bg_normal)
	send_icon.hide()
