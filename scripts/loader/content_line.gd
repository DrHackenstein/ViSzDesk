extends Node
class_name ContentLine

var id : String
var app : String
var character_id : String
var parameters : Array
var delay : int
var content : String
var triggers : Array

func get_character() -> Character:
	return Characters.get_character(character_id)
