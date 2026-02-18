extends Node

var config = ConfigFile.new()

# Config path
var config_path = "res://config.cfg"
var readme_path = "res://README.txt"
var readme_path_default = "res://README.txt"
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
var boot_os_start_sound_id = "play_os_start_jingle"
var boot_os_start_sound = true
var boot_autostart_id = "autostart_apps"
var boot_autostart = ""
var boot_configs = [[boot_show_id, "boot_show"],[boot_spinner_delay_id, "boot_spinner_delay"], [boot_audio_id, "boot_audio"], [boot_idle_time_id, "boot_idle_time"], [boot_os_start_sound_id, "boot_os_start_sound"], [boot_autostart_id, "boot_autostart"] ]

var content_section = "content"
var content_spreadsheet_id = "content"
var content_spreadsheet = "szenario.csv"
var content_spreadsheet_default = "szenario.csv"
var content_spreadsheet_start_id = "szenario_start_id"
var content_spreadsheet_start = ""
var content_characters_id = "characters"
var content_characters = "characters.csv"
var content_characters_default = "characters.csv"
var content_wallpaper_id = "wallpaper"
var content_wallpaper = "wallpaper.png"
var content_wallpaper_default = "wallpaper.png"
var content_textfiles_id = "text_files"
var content_textfiles = "credits.txt"
var content_textfiles_default = "credits.txt"
var content_time_id = "clock_start_time"
var content_time = "22:01"
var content_show_date_id = "clock_show_date"
var content_show_date = true
var content_date_id = "clock_start_date"
var content_date = "08.02.2026"
var content_debug_id = "debug_mode"
var content_debug = false
var content_configs = [[content_spreadsheet_id,"content_spreadsheet"],[content_spreadsheet_start_id,"content_spreadsheet_start"],[content_characters_id,"content_characters"], [content_wallpaper_id,"content_wallpaper"], [content_textfiles_id, "content_textfiles"], [content_time_id,"content_time"], [content_date_id,"content_date"], [content_show_date_id,"content_show_date"], [content_debug_id,"content_debug"]]

var modules_section = "modules"
var modules_chat_id = "chat"
var modules_chat = true
var modules_chat_name_id = "chat_name"
var modules_chat_name = "Chat"
var modules_chat_beep_id = "play_chat_notification_beep"
var modules_chat_beep = true
var modules_chat_beep_sound_id = "chat_notification_beep_sound"
var modules_chat_beep_sound = ""
var modules_moderation_id = "moderation"
var modules_moderation = true
var modules_moderation_name_id = "moderation_name"
var modules_moderation_name = "Moderation"
var modules_mod_beep_id = "play_mod_notification_beep"
var modules_mod_beep = true
var modules_mod_beep_sound_id = "mod_notification_beep_sound"
var modules_mod_beep_sound = ""
var modules_configs = [[modules_chat_id, "modules_chat"],[modules_chat_name_id, "modules_chat_name"],[modules_chat_beep_id, "modules_chat_beep"],[modules_chat_beep_sound_id, "modules_chat_beep_sound"], [modules_moderation_id, "modules_moderation"], [modules_moderation_name_id, "modules_moderation_name"], [modules_mod_beep_id, "modules_mod_beep"], [modules_mod_beep_sound_id, "modules_mod_beep_sound"]]

func _ready() -> void:
	if not OS.has_feature("editor"):
		get_config_path()
		
	load_config()
	generate_readme()

	# Create content folder, if it doesn't already exist
	if not DirAccess.dir_exists_absolute(content_path):
		DirAccess.make_dir_absolute(content_path)

func generate_readme():
	# Try to load readme.txt, if there is none create default and use that
	if not FileAccess.file_exists(readme_path):
		var file = FileAccess.open(readme_path_default, FileAccess.READ)
		var new = FileAccess.open(readme_path, FileAccess.WRITE)
		new.store_string(file.get_as_text())
		new.close()
		
func get_config_path():
	config_path = OS.get_executable_path().get_base_dir() + "/config.cfg"
	readme_path = OS.get_executable_path().get_base_dir() + "/README.txt"
	content_path = OS.get_executable_path().get_base_dir() + "/content"

func load_config():
	# Create new config file if it doesn't already exist
	if not FileAccess.file_exists(config_path):
		push_warning("Loading Error: Couldn't find config at " + config_path)
		FileAccess.open(config_path, FileAccess.READ_WRITE)
		create_new_config()
	else:
		# Try to load config, if faulty create new
		var err = config.load(config_path)
		if err != OK:
			push_error("Loading Error: Couldn't read config at " + config_path + ". Copying faulty config to " + config_path + "_error")
			var loaded_file = FileAccess.open(config_path, FileAccess.READ).get_as_text()
			var faulty_config = FileAccess.open(config_path + "_error", FileAccess.READ_WRITE)
			faulty_config.store_string(loaded_file)
			faulty_config.close()
			create_new_config()
		else:
			load_existing_config()

func create_new_config():
	print("Creating new default config at " + config_path)
	config.clear()
	
	for value in boot_configs:
		config.set_value(boot_section, value[0], get(value[1]))
	
	for value in content_configs:
		config.set_value(content_section, value[0], get(value[1]))
	
	for value in modules_configs:
		config.set_value(modules_section, value[0], get(value[1]))
		
	config.save(config_path)

func load_existing_config():
	
	for value in boot_configs:
		set(value[1], config.get_value(boot_section, value[0], get(value[1])))
	
	for value in content_configs:
		set(value[1], config.get_value(content_section, value[0], get(value[1])))
	
	for value in modules_configs:
		set(value[1], config.get_value(modules_section, value[0], get(value[1])))
