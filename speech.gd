extends Node

var voice_id := DisplayServer.tts_get_voices_for_language("en")[0]

@onready var caption := get_node("/root/YachtSinkers/Caption")

func say(text: String, interrupt=false) -> void:
	caption.text = text
	#caption.accessibility_name = text
	#print("Speaking: " + text)
	#if interrupt:
		#DisplayServer.tts_stop()
	#DisplayServer.tts_speak(text, voice_id)

#func say(text: String, interrupt=false) -> void:
	#GodotARIA.debug = true
	#if interrupt:
		#GodotARIA.alert_screen_reader(text)
	#else:
		#GodotARIA.notify_screen_reader(text)
