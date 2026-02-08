extends HBoxContainer

@export var timer : Timer
@export var label : Label

var date = ""
var hour = 22
var minute = 1
var text

func _ready():
	timer.timeout.connect(add_minute)
	
	# Setup Start Time
	var start_time = Time.get_time_string_from_system().split(":")
		
	if not Config.content_time == "" and Config.content_time.split(":").size() > 1:
		start_time = Config.content_time.split(":")
	
	hour = int(start_time[0])
	minute = int(start_time[1])

	# Setup Start Date
	if Config.content_show_date:
		var start_date = Time.get_date_string_from_system().split("-")
		start_date = start_date[1] + "." + start_date[2] + "." + start_date[0]
		if not Config.content_date == "" and Config.content_date.split(".").size() > 2:
			start_date = Config.content_date.split(".")
	
		date = start_date[0] + "." + start_date[1] + "." + start_date[2]
	
	update_label()

func add_minute():
	minute += 1
	
	if minute == 60:
		minute = 0
		hour += 1
	
	if hour == 24:
		hour = 0
		if not date == "":
			var d = date.split(".")
			date = str( int(d[0]) + 1) + "." + d[1] + "." + d[2]
	
	update_label()


func update_label():
	if hour < 10 : 
		text = "0" + str(hour)
	else:
		text = str(hour)
	
	text += ":"
	
	if minute < 10 :
		text += "0" + str(minute)
	else:
		text += str(minute)
	
	if not date == "":
		text += "\n" + date
	
	label.text = text
