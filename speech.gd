extends Node

func say(text: String, interrupt=false) -> void:
	GodotARIA.debug = true
	if interrupt:
		GodotARIA.alert_screen_reader(text)
	else:
		GodotARIA.notify_screen_reader(text)
