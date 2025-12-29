extends Node

var config = ConfigFile.new()

# Config path
var config_path = "res://config.cfg"
var content_path = "res://content"
var content_path_default = "res://content"

# Config values
var boot_section = "booting"
var boot_show_id = "show_boot_sequence"
var boot_show = true
var boot_spinner_delay_id = "boot_spinner_delay"
var boot_spinner_delay = 3
var boot_audio_id = "play_boot_audio"
var boot_audio = true
var boot_idle_time_id = "boot_idle_duration"
var boot_idle_time = 6

var content_section = "content"
var content_spreadsheet_id = "spreadsheet"
var content_spreadsheet = "spreadsheet.csv"
var content_spreadsheet_default = "spreadsheet.csv"
var content_wallpaper_id = "wallpaper"
var content_wallpaper = "wallpaper.jpg"
var content_wallpaper_default = "wallpaper.jpg"

var modules_section = "modules"
var modules_chat_id = "chat"
var modules_chat = true
var modules_moderation_id = "moderation"
var modules_moderation = true

func _ready() -> void:
	
	if not OS.has_feature("editor"):
		get_config_path()
		
	load_config()

	# Create content folder, if it doesn't already exist
	if not DirAccess.dir_exists_absolute(content_path):
		DirAccess.make_dir_absolute(content_path)

func get_config_path():
	config_path = OS.get_executable_path().get_base_dir() + "/config.cfg"
	content_path = OS.get_executable_path().get_base_dir() + "/content"

	# Create new config file if it doesn't already exist
	if not FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ_WRITE)
		file.close()

func load_config():
	# Try to load config, if missing or faulty, write new config
	var err = config.load(config_path)
	if err != OK:
		create_new_config()
	else:
		load_existing_config()

func create_new_config():
	print("Config faulty or missing, writing new at " + OS.get_executable_path().get_base_dir())
	config.clear()
	config.set_value(boot_section, boot_show_id, boot_show)
	config.set_value(boot_section, boot_spinner_delay_id, boot_spinner_delay)
	config.set_value(boot_section, boot_audio_id, boot_audio)
	config.set_value(boot_section, boot_idle_time_id, boot_idle_time)
	config.set_value(content_section, content_spreadsheet_id, content_spreadsheet)
	config.set_value(content_section, content_wallpaper_id, content_wallpaper)
	config.set_value(modules_section, modules_chat_id, modules_chat)
	config.set_value(modules_section, modules_moderation_id, modules_moderation)
	config.save(config_path)

func load_existing_config():
	boot_show = config.get_value(boot_section, boot_show_id, boot_show)
	boot_audio = config.get_value(boot_section, boot_spinner_delay_id, boot_spinner_delay)
	boot_audio = config.get_value(boot_section, boot_audio_id, boot_audio)
	boot_idle_time = config.get_value(boot_section, boot_idle_time_id, boot_idle_time)
	content_spreadsheet = config.get_value(content_section, content_spreadsheet_id, content_spreadsheet)
	content_wallpaper = config.get_value(content_section, content_wallpaper_id, content_wallpaper)
	modules_chat = config.get_value(modules_section, modules_chat_id, modules_chat)
	modules_moderation = config.get_value(modules_section, modules_moderation_id, modules_moderation)
	
