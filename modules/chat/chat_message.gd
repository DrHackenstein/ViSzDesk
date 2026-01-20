extends MarginContainer
class_name ChatMessage

@export var label : RichTextLabel

func setup(msg : String):
	label.text = msg
	scrolldown()
	
func scrolldown():
	await get_tree().process_frame
	await get_tree().process_frame
	var scrollcontainer = get_parent().get_parent()
	var scrollbar = scrollcontainer.get_v_scroll_bar()
	scrollcontainer.scroll_vertical = scrollbar.max_value
