extends Node

var headers = []
var content = [[]]
var start_id = null

# Data Columns
var id_index = 0
var app_index = 1
var char_index = 2
var parameters_index = 3
var delay_index = 4
var content_index = 5
var triggers_index = 6

func _ready():
	load_content_file()
	load_first()

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
	content = {}
	
	var data
	
	while !file.eof_reached():
		
		# Load Line
		data = file.get_csv_line()
		
		# Catch empty lines
		if data == null or data.size() < 6:
			print("Couldn't read line! (Size:" + str(data.size()) +")")
			return
		
		# Read Headers
		if headers.is_empty():
			read_headers(data)
			continue
		
		# Get Start Line
		if start_id == null:
			start_id = data[0]
		
		# Read Content
		read_line(data)
		
	file.close()

func read_headers( data : Array ):
	var index = 0
	for field in data:
		var header = field.remove_chars(" ").to_upper()
		match header:
			"ID":
				id_index = index
			"APP":
				app_index = index
			"CID":
				char_index = index
			"PARAMETERS": 
				parameters_index = index
			"DELAY": 
				delay_index = index
			"CONTENT": 
				content_index = index
			"TRIGGERS": 
				triggers_index = index
		
		headers.append(field)
		index += 1

func read_line( data : Array ):
	var line = ContentLine.new()
	
	line.id = data[id_index]
	line.app = data[app_index]
	line.character_id = data[char_index]
	line.parameters = data[parameters_index].split(",")
	line.delay = data[delay_index]
	line.content = data[content_index]
	line.triggers = data[triggers_index].split(",")
	
	content.set(line.id, line)

func load_first():
	process_content_line(start_id)
	
func process_content_line( id : String):
	# Get line
	var line = content.get(id)
	if line == null:
		print("Couldn't process content line with id: " + id)
		return
	
	# Handle Delay
	await get_tree().create_timer(line.delay).timeout
	
	## Pass on to App
	var app = line.app.remove_chars(" ").to_lower()
	match line.app:
		"chat":
			%Chat.trigger_content(line)
		"mod":
			%Mod.trigger_content(line)
