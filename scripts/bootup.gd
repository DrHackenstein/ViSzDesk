extends Popup

@export var background : ColorRect
@export var progress_spinner : TextureProgressBar
@export var text : Label
@export var audio_player : AudioStreamPlayer2D

var progress_spinner_animation : Tween
var os_start_jingle : AudioStream

func _ready() -> void:
	self.popup_window = false
	
	if Config.boot_os_start_sound:
		os_start_jingle = load("res://sounds/351877__marlonnnnnn__start-computer.wav")
	
	if Config.boot_show and not OS.has_feature("editor"):
		background.color = Color.BLACK
		show()
		setup_spinner()
		play_audio()
		
		await get_tree().create_timer(Config.boot_spinner_delay).timeout
		show_spinner()
		
		await get_tree().create_timer(Config.boot_idle_time).timeout
		close()
		
	else:
		load_desktop()
	
func setup_spinner():
	progress_spinner_animation = get_tree().create_tween().set_loops()
	progress_spinner_animation.tween_property(progress_spinner, "radial_initial_angle", 360.0, 1.5).as_relative()

func show_spinner():
	text.show()
	progress_spinner.show()

func play_audio():
	var duration = Config.boot_spinner_delay + Config.boot_idle_time
	if Config.boot_audio and duration > 0:
		audio_player.play()
		await get_tree().create_timer(duration - 1).timeout
		var tween_out: Tween = get_tree().create_tween()
		tween_out.tween_property(audio_player, "volume_db", -80, 1)
		await tween_out.finished
		audio_player.stop()
	
func close():
	text.hide()
	progress_spinner.hide()
	progress_spinner_animation.stop()
		
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(background, "color", Color.TRANSPARENT, 0.5)
	await get_tree().create_timer(1).timeout
	hide()
	load_desktop()
	
func load_desktop():
	if Config.boot_os_start_sound:
		print("Play jingle")
		audio_player.stream = os_start_jingle
		audio_player.volume_db = 0
		audio_player.play()
	
	await audio_player.finished
	queue_free()
