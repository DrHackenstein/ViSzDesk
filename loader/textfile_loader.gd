extends Node

var desktop_button
var taskbar_button
var text_window

func _ready() -> void:
	load_components()
	load_textfiles()


func load_components():
	desktop_button = preload("res://window_management/desktop_button.tscn")
	taskbar_button = preload("res://window_management/taskbar_button.tscn")
	text_window = preload("res://window_management/text_window.tscn")
	
func load_textfiles():
	# Get filenames
	var files = Config.content_textfiles.remove_chars(" ").split(",")
	
	# Load files
	for filename : String in files:
		if FileAccess.file_exists(Config.content_path + "/" + filename):
			var file = FileAccess.open(Config.content_path + "/" + filename, FileAccess.READ)
			load_file(file.get_as_text(), filename)
		# Generate default credits.txt if it's referenced, but not in the content folder
		elif filename == Config.content_textfiles_default:
			var file = FileAccess.open(Config.content_path_default + "/" + filename, FileAccess.READ)
			var new = FileAccess.open(Config.content_path + "/" + filename, FileAccess.WRITE)
			new.store_string(file.get_as_text())
			new.close()
			load_file(file.get_as_text(), filename)
		else:
			push_warning("Loading Error: Couldn't find text file " + filename + " in " + Config.content_path + "/")

func load_file( content : String, filename : String ):
	# Instantiate components
	var button = desktop_button.instantiate()
	var taskbar = taskbar_button.instantiate()
	var window = text_window.instantiate()
	
	#Setup Desktop Button
	get_node("/root/Main/%DesktopSpace").add_child(button)
	button.setup(window, taskbar, filename)
	
	# Setup Taskbar Button
	var appsbar = get_node("/root/Main/%Appsbar")
	appsbar.add_child(taskbar)
	appsbar.move_child(taskbar, appsbar.get_child_count() - 2)
	taskbar.menu = window
	
	# Setup Window
	get_node("/root/Main/").add_child(window)
	window.setup(content, taskbar, filename)
	
	# Hide window if it isn't in autostart
	if not Config.boot_autostart.remove_chars(" ").split(",").has(filename):
		taskbar.hide()
		window.hide()
