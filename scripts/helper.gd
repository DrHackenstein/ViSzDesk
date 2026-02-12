extends Node

func load_audio_file( filepath : String ) -> AudioStream:
	if filepath.ends_with(".mp3"):
		return AudioStreamMP3.load_from_file(filepath)
	elif filepath.ends_with(".ogg"):
		return AudioStreamOggVorbis.load_from_file(filepath)
	elif filepath.ends_with(".wav"):
		return AudioStreamWAV.load_from_file(filepath)
	return null

func is_supported_audio_format( filename : String ) -> bool:
	var file = filename.to_lower()
	if file.ends_with(".mp3"):
		return true
	elif file.ends_with(".ogg"):
		return true
	if file.ends_with(".wav"):
		return true
	else:
		return false

func is_supported_video_format( filename : String ) -> bool:
	var file = filename.to_lower()
	if file.ends_with(".ogv"):
		return true
	else:
		return false

func is_supported_image_format( filename : String ) -> bool:
	var file = filename.to_lower()
	return file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".ktx") or file.ends_with(".svg") or file.ends_with(".tga") or file.ends_with(".webp")

func seconds_to_time_string( time : float ) -> String:
	return seconds_int_to_time_string( roundi(time) )
	
func seconds_int_to_time_string( time : int ) -> String:
	var min = time / 60
	var sec = time % 60
	return "%02d:%02d" % [min%60, sec%60]
