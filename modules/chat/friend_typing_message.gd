extends MarginContainer
@export var label : RichTextLabel
@export var timer : Timer

func _ready():
	timer.timeout.connect(update_timer)

func update_timer():
	match label.text:
		".":
			label.text = ".."
		"..":
			label.text = "..."
		_:
			label.text = "."
