extends Node
class_name ContentLine

var id : String
var app : String
var character_id : String
var parameters : Array
var delay : int
var content : String
var triggers : Array

func handle_triggers():
	for id in triggers:
		%Content.process_content_line(id)

func get_character() -> Character:
	return %Characters.characters.get_character(character_id)
