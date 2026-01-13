extends MarginContainer

@export var friend_name : Label
@export var friend_pic : TextureRect

func setup( character : Character ):
	print("Setup friend_button for " + character.character_name)
	friend_name.text = character.character_name
	friend_pic.texture = ImageTexture.create_from_image(character.character_image)
