extends Node

var headers = []
var content = [[]]

func _ready():
	load_content_file()

func load_content_file():
	# If content spreadhseet is missing, overwrite with default
	if not FileAccess.file_exists(%Config.content_path + "/" + %Config.content_spreadsheet):
		print("Loading Error: Couldn't find content spreadsheet at " + %Config.content_path + "/" + %Config.content_spreadsheet + "!\nCreating default spreadsheet there.")
		var default = FileAccess.open(%Config.content_path_default + "/" + %Config.content_spreadsheet_default, FileAccess.READ)
		var new = FileAccess.open(%Config.content_path + "/" + %Config.content_spreadsheet, FileAccess.WRITE)
		new.store_string(default.get_as_text())
		new.close()
	
	var file = FileAccess.open(%Config.content_path + "/" + %Config.content_spreadsheet, FileAccess.READ)
	
	if file == null:
		print("Couldn't load csv!")
		return
	
	# Reset Variables
	headers = []
	content = [[]]
	
	var data
	
	while !file.eof_reached():
		
		# Load Line
		data = file.get_csv_line()
		
		# Catch empty lines
		if data == null:
			print("Couldn't read line! (Size:" + str(data.size()) +")")
			print(data.join(""))
			return
		
		# Read Headers
		if headers.is_empty():
			for field in data:
				headers.append(field) 
			continue
		
		#Read Content
		content.append(data.duplicate())
		
	file.close()
