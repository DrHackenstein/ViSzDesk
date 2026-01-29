extends Node

var focus = null
var windows = []

func add( window ):
	if not windows.has(window):
		windows.push_front(window)

func remove( window ):
	if windows.find(window) == 0 and windows.size() > 1:
		windows.erase(window)
		windows[0].grab_focus()
	else:
		windows.erase(window)

func gain_focus( window ):
	if not windows.has(window):
		windows.push_front(window)
	elif not windows.find(window) == 0:
		windows.erase(window)
		windows.push_front(window)

func lose_focus( window ):
	if windows.find( window ) == 0 and windows.size() > 1:
		windows.erase(window)
		windows.insert(1, window)
		windows[0].grab_focus()

func has_focus( window ) -> bool:
	return windows.find(window) == 0
