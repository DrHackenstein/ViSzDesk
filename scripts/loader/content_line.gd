extends Node
class_name ContentLine

var id : String
var app : String
var character : String
var parameters : Array
var delay : int
var content : String
var triggers : Array

func handle_triggers():
	for id in triggers:
		%Content.process_content_line(id)
