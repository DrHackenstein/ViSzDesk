extends VBoxContainer
class_name ChatContainer

@export var messageContainer : VBoxContainer
@export var responseContainer : VBoxContainer
@export var friendName : Label
@export var friendPic : TextureRect

func setup( character : Character ):
	friendName.text = character.character_name
	friendPic.texture = ImageTexture.create_from_image(character.character_image)
