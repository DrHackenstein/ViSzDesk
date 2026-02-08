extends Control
class_name AudioPlayer

@export var audio : AudioStreamPlayer2D
@export var button_play : TextureButton
@export var button_pause : TextureButton
@export var progress : ProgressBar

func _ready() -> void:
	button_play.button_up.connect(on_click)
	button_pause.button_up.connect(on_click)
	audio.finished.connect(stop)

func setup( filepath : String ):
	var stream = Helper.load_audio_file(filepath)
	if stream == null:
		push_warning("Couldn't load " + filepath + ": Audio Stream is null!")
		return
	audio.stream = stream
	progress.max_value = stream.get_length()

func on_click():
	if audio.playing:
		stop()
	else:
		play()

func play():
	if audio.stream_paused:
		audio.stream_paused = false
	else:
		audio.play()
	button_play.hide()
	button_pause.show()

func stop():
	audio.stream_paused = true
	button_pause.hide()
	button_play.show()

func _process(delta: float) -> void:
	if audio.playing:
		progress.value = audio.get_playback_position()
