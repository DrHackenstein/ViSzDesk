extends Node

var headers = []
var content = {}
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
	self.call_deferred("load_first")

func load_content_file():
	# If content spreadhseet is missing, overwrite with default
	if not FileAccess.file_exists(Config.content_path + "/" + Config.content_spreadsheet):
		push_warning("Loading Error: Couldn't find content spreadsheet at " + Config.content_path + "/" + Config.content_spreadsheet + "!\nCreating default spreadsheet there.")
		var default = FileAccess.open(Config.content_path_default + "/" + Config.content_spreadsheet_default, FileAccess.READ)
		var new = FileAccess.open(Config.content_path + "/" + Config.content_spreadsheet, FileAccess.WRITE)
		new.store_string(default.get_as_text())
		new.close()
	
	var file = FileAccess.open(Config.content_path + "/" + Config.content_spreadsheet, FileAccess.READ)
	
	if file == null:
		push_error("Loading Error: Couldn't read " + Config.content_path + "/" + Config.content_spreadsheet)
		return
	else:
		print("Loading " + Config.content_path + "/" + Config.content_spreadsheet + " ...")
	
	# Reset Variables
	headers.clear()
	content.clear()
	
	var data
	var line = -1
	
	while !file.eof_reached():
		
		# Load Line
		data = file.get_csv_line()
		line += 1
		
		# Catch empty lines
		if data == null:
			push_warning("Couldn't read line " + str(line) + ": No content (null)")
		elif data.size() < 7:
			push_warning("Couldn't read line " + str(line) + ": Need 7 columns (" + str(data.size()) +")")
			continue
		
		# Read Headers
		if headers.is_empty():
			read_headers(data)
			continue
		
		# Get Start Line
		if start_id == null:
			start_id = data[id_index]
		
		# Read Content
		read_line(data, line)
		
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

func read_line( data : Array, lineNumber : int ):
	var line = ContentLine.new()
	
	# Ignore empty ID lines
	if data[id_index] == "":
		push_warning("Scenario line " + str(lineNumber) + " has no id. Line was ignored.")
		return
	
	# Ignore duplicate ID lines
	if content.has(data[id_index]):
		push_warning("Scenario line " + str(lineNumber) + " id (" + line.id + ") already exists. Line was ignored.")
		return
	
	line.id = data[id_index].remove_chars(" ")
	line.app = data[app_index].remove_chars(" ")
	line.character_id = data[char_index].remove_chars(" ")
	line.parameters = data[parameters_index].remove_chars(" ").split(",")
	line.delay = int(data[delay_index].remove_chars(" "))
	line.content = data[content_index]
	line.triggers = data[triggers_index].remove_chars(" ").split(",")
	
	content.set(line.id, line)

func load_first():
	if start_id == null:
		push_error("No Start ID found! Can't start scenario.")
		return
	else:
		print("Start Szenario with " + start_id)
		process_content_line(start_id, "")
	
func process_content_line( id : String, parent : String ):
	# Get line
	var line = content.get(id)
	if line == null:
		print("Couldn't process content line with id: " + id)
		return
	else:
		line.parent = parent
	
	# Handle Delay
	if not Config.content_debug:
		await get_tree().create_timer(line.delay).timeout
	
	## Pass on to App
	var app = line.app.remove_chars(" ").to_lower()
	match app:
		"chat":
			get_node("/root/Main/%Chat").trigger_content(line)
		"mod":
			get_node("/root/Main/%Mod").trigger_content(line)
		_:
			for trigger in line.triggers:
				if not trigger == null:
					process_content_line(trigger, id)
