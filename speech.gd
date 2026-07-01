extends Node

func say(text: String, interrupt=false) -> void:
	if interrupt:
		GodotARIA.alert_screen_reader(text)
	else:
		GodotARIA.notify_screen_reader(text)
