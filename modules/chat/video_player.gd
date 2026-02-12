extends Container
class_name VideoPlayer

@export var video : VideoStreamPlayer
@export var button_play : TextureButton
@export var button_pause : TextureButton
@export var progress : ProgressBar
@export var duration : Label
var video_width = 334

func _ready() -> void:
	button_play.button_up.connect(on_click)
	button_pause.button_up.connect(on_click)
	video.finished.connect(handle_finished)

func setup( filepath : String ):
	var vid = VideoStreamTheora.new()
	vid.file = filepath
	video.stream = vid
	
	var ratio = video.get_video_texture().get_width() / float(video.get_video_texture().get_height())
	video.custom_minimum_size = Vector2(video_width, video_width / ratio)
	progress.max_value = video.get_stream_length()
	duration.text = Helper.seconds_to_time_string(video.get_stream_length())

func on_click():
	if not video.is_playing() or video.paused:
		play()
	else:
		stop()

func play():
	if video.paused:
		video.paused = false
	else:
		video.play()
	button_play.hide()
	button_pause.show()

func stop():
	video.paused = true
	button_pause.hide()
	button_play.show()

func handle_finished():
	button_pause.hide()
	button_play.show()
	duration.text = Helper.seconds_to_time_string(video.get_stream_length())

func _process(delta: float) -> void:
	if video.is_playing() and not video.paused:
		progress.value = video.stream_position
		duration.text = Helper.seconds_to_time_string(video.stream_position)
