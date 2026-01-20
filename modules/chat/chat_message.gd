extends MarginContainer
class_name ChatMessage

@export var label : RichTextLabel

func setup( line : ContentLine ):
	if Config.content_debug:
		label.text = line.id + ": " + line.content + " (Trigger: " + ",".join(line.triggers) +")"
	else:
		label.text = line.content
	
	scrolldown()
	
func scrolldown():
	await get_tree().process_frame
	await get_tree().process_frame
	var scrollcontainer = get_parent().get_parent()
	var scrollbar = scrollcontainer.get_v_scroll_bar()
	scrollcontainer.scroll_vertical = scrollbar.max_value
