extends Popup

@export var background : ColorRect
@export var progress_spinner : TextureProgressBar
@export var text : Label
@export var audio_player : AudioStreamPlayer2D

func _ready() -> void:
	self.popup_window = false
	
	if %Config.boot_show:
		background.color = Color.BLACK
		setup_spinner()
		setup_audio()
		
		await get_tree().create_timer(%Config.boot_spinner_delay).timeout
		show_spinner()
		
		await get_tree().create_timer(%Config.boot_idle_time).timeout
		close()
		
	else:
		load_desktop()
	
func setup_spinner():
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(progress_spinner, "radial_initial_angle", 360.0, 1.5).as_relative()

func show_spinner():
	text.show()
	progress_spinner.show()

func setup_audio():
	var duration = %Config.boot_spinner_delay + %Config.boot_idle_time
	if %Config.boot_audio and duration > 0:
		audio_player.play()
		await get_tree().create_timer(duration - 1).timeout
		var tween_out: Tween = get_tree().create_tween()
		tween_out.tween_property(audio_player, "volume_db", -80, 1)
		await tween_out.finished
		audio_player.stop()
	
func close():
	text.hide()
	progress_spinner.hide()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(background, "color", Color.TRANSPARENT, 0.3)
	await get_tree().create_timer(1).timeout
	load_desktop()
	
func load_desktop():
	#%Music_Player.play()
	#await get_tree().create_timer(1).timeout
	#%Mod_Window.show()
	#await get_tree().create_timer(1).timeout
	#%Guideline.show()
	#%Content_Manager.start_game()
	
	queue_free()
