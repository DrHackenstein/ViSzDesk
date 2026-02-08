extends Container
class_name VideoPlayer

@export var video : VideoStreamPlayer
@export var button_play : TextureButton
@export var button_pause : TextureButton
@export var progress : ProgressBar

func _ready() -> void:
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)
	button_play.button_up.connect(on_click)
	button_pause.button_up.connect(on_click)
	video.finished.connect(show_button)

func setup( filepath : String ):
	var vid = VideoStreamTheora.new()
	vid.file = filepath
	video.stream = vid
	progress.max_value = video.get_stream_length()
	
func on_mouse_enter():
	show_button()
	
func on_mouse_exit():
	hide_button()

func on_click():
	if not video.is_playing():
		video.play()
		button_play.hide()
		button_pause.show()
	elif video.paused:
		video.paused = false
		button_play.hide()
		button_pause.show()
	else:
		video.paused = true
		button_play.show()
		button_pause.hide()
	

func show_button():
	if video.is_playing() and not video.paused:
		button_pause.show()
	else:
		button_play.show()
		
func hide_button():
		button_pause.hide()
		button_play.hide()

func _process(delta: float) -> void:
	if video.is_playing() and not video.paused:
		progress.value = video.stream_position
