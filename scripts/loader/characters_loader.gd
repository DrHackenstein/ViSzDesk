extends Node

var default_character_pic = "default_character.png"
var characters = {}

func _ready():
	print("Loading characters")
	load_content_file()

func load_content_file():
	# If content spreadhseet is missing, overwrite with default
	if not FileAccess.file_exists(%Config.content_path + "/" + %Config.content_characters):
		print("Loading Error: Couldn't find characters spreadsheet at " + %Config.content_path + "/" + %Config.content_characters + "!\nCreating default spreadsheet there.")
		var default = FileAccess.open(%Config.content_path_default + "/" + %Config.content_characters_default, FileAccess.READ)
		var new = FileAccess.open(%Config.content_path + "/" + %Config.content_characters, FileAccess.WRITE)
		new.store_string(default.get_as_text())
		new.close()
	
	var file = FileAccess.open(%Config.content_path + "/" + %Config.content_characters, FileAccess.READ)
	
	if file == null:
		print("Couldn't load character csv!")
		return
	
	# Reset Variables
	characters.clear()
	
	var line = -1
	var data
	
	while !file.eof_reached():
		line += 1
		
		# Load Line
		data = file.get_csv_line()
		
		# Catch empty lines
		if data == null:
			print("Couldn't read character line! (Size:" + str(data.size()) +")")
			print(data.join(""))
			return
		
		# Read Headers
		if line == 0:
			print("Skip Headers")
			continue
		
		#Read Content
		if data.size() > 2:
			var char = Character.new()
			char.character_id = data[0]
			char.character_name = data[1]
			
			# Try to load image, if there is none use default
			var image : CompressedTexture2D
			if not FileAccess.file_exists(%Config.content_path + "/" + data[2]):
				if not FileAccess.file_exists(%Config.content_path + "/" + default_character_pic):
					print("Loading Error: Couldn't find character pic " + %Config.content_path + "/" + data[2] + ". Created default pic to use instead.")
					image = load(%Config.content_path_default + "/" + default_character_pic)
					image.get_image().save_png(%Config.content_path + "/" + default_character_pic)
				else:
					print("Loading Error: Couldn't find character pic " + %Config.content_path + "/" + data[2] + ". Using default pic instead.")
					image = load(%Config.content_path_default + "/" + default_character_pic)
				char.character_image = image.get_image()
			else:
				char.character_image = Image.load_from_file(%Config.content_path + "/" + data[2])
			
			characters.set(char.character_id, char)
	
	file.close()

func get_character( id : String ) -> Character:
	if characters.has(id):
		return characters[id]
	else:
		print("Couldn't find character id \"" + id + "\" added placeholder Character instead")
		var char = Character.new()
		char.character_id = id
		char.character_name = id
		char.character_image = load(%Config.content_path_default + "/" + default_character_pic).get_image()
		characters.set(char.character_id, char)
		return char
