extends Node

var default_character_pic = "default_character.png"
var internal_pic_path = "res://images/avatars/"
var headers = []
var characters = {}

var cid_index
var name_index
var pic_index

func _ready():
	load_content_file()

func load_content_file():
	# If content spreadhseet is missing, overwrite with default
	if not FileAccess.file_exists(Config.content_path + "/" + Config.content_characters):
		push_warning("Loading Error: Couldn't find characters spreadsheet at " + Config.content_path + "/" + Config.content_characters + "!\nCreating default spreadsheet there.")
		var default = FileAccess.open(Config.content_path_default + "/" + Config.content_characters_default, FileAccess.READ)
		var new = FileAccess.open(Config.content_path + "/" + Config.content_characters, FileAccess.WRITE)
		new.store_string(default.get_as_text())
		new.close()
	
	var file = FileAccess.open(Config.content_path + "/" + Config.content_characters, FileAccess.READ)
	
	if file == null:
		push_error("Loading Error: Couldn't load " + Config.content_path + "/" + Config.content_characters)
		return
	else:
		print("Loading " +  Config.content_path + "/" + Config.content_characters + " ...")
	
	# Reset Variables
	characters.clear()
	headers.clear()
	
	var line = -1
	var data
	
	while !file.eof_reached():
		line += 1
		
		# Load Line
		data = file.get_csv_line()
		
		# Catch empty lines
		if data == null or data.size() < 3:
			print("Couldn't read line " + str(line) + ": ".join(data) + " (Size:" + str(data.size()) +")")
			continue
			
		# Read Headers
		if headers.is_empty():
			read_headers(data)
			continue
		
		#Read Content
		if data.size() > 2:
			var character = Character.new()
			character.character_id = data[cid_index]
			character.character_name = data[name_index]
			load_avatar(character, data[pic_index])
			characters.set(character.character_id, character)
	
	file.close()

func read_headers( data : Array ):
	var index = 0
	for field in data:
		var header = field.remove_chars(" ").to_upper()
		match header:
			"CID":
				cid_index = index
			"NAME":
				name_index = index
			"PIC":
				pic_index = index
		
		headers.append(field)
		index += 1

func load_avatar( character : Character, filename : String ):
	# Try load internal character pic
	var start = filename.find("[")
	var end = filename.find("]")
	if start > -1 and end > -1:
		var internal_filename = filename.substr(start + 1, end - start - 1) + ".png"
		if internal_filename.is_valid_filename() and ResourceLoader.exists(internal_pic_path + internal_filename):
			character.character_image = load(internal_pic_path + internal_filename)
		else:
			push_warning("Couldn't load character pic " + filename + ": Not a valid internal character pic.")
	
	# Try to load image, if there is none use default
	elif not FileAccess.file_exists(Config.content_path + "/" + filename):
		var image : Image
		if not FileAccess.file_exists(Config.content_path + "/" + default_character_pic):
			print("Loading Error: Couldn't find character pic " + Config.content_path + "/" + filename + ". Created default pic to use instead.")
			image = load(Config.content_path_default + "/" + default_character_pic)
			image.save_png(Config.content_path + "/" + default_character_pic)
		else:
			print("Loading Error: Couldn't find character pic " + Config.content_path + "/" + filename + ". Using default pic instead.")
			image = load(Config.content_path_default + "/" + default_character_pic)
		character.character_image = image
	else:
		character.character_image = Image.load_from_file(Config.content_path + "/" + filename)

func get_character( id : String ) -> Character:
	if characters.has(id):
		return characters[id]
	else:
		print("Couldn't find character id \"" + id + "\" added placeholder Character instead")
		var character = Character.new()
		character.character_id = id
		character.character_name = id
		character.character_image = load(Config.content_path_default + "/" + default_character_pic)
		characters.set(character.character_id, character)
		return character
