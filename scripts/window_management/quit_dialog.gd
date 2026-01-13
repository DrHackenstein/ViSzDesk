extends ConfirmationDialog

@export var BackgroundDim : ColorRect

func _ready() -> void:
	get_ok_button().pressed.connect(quit_game)
	get_cancel_button().pressed.connect(hide_dialog)
	close_requested.connect(hide_dialog)
	visibility_changed.connect(handle_hide_show)

func handle_hide_show():
	if visible:
		BackgroundDim.show()
	else:
		BackgroundDim.hide()

func quit_game():
	get_tree().quit()

func hide_dialog():
	hide()
	BackgroundDim.hide()
