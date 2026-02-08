extends TextureButton

@export var texture_default_normal : Texture2D
@export var texture_default_pressed : Texture2D
@export var texture_default_hover : Texture2D
@export var texture_muted_normal : Texture2D
@export var texture_muted_pressed : Texture2D
@export var texture_muted_hover : Texture2D

@onready var master = AudioServer.get_bus_index("Master")

var muted = false

func _ready() -> void:
	button_down.connect(toggle_mute)

func toggle_mute():
	muted = not muted
	AudioServer.set_bus_mute(master, muted)
	
	if muted:
		texture_normal = texture_muted_normal
		texture_pressed = texture_muted_pressed
		texture_hover = texture_muted_hover
	else:
		texture_normal = texture_default_normal
		texture_pressed = texture_default_pressed
		texture_hover = texture_default_hover
