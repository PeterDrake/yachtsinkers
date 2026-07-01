extends Node

var voice_id := DisplayServer.tts_get_voices_for_language("en")[0]

func say(text: String, interrupt=false) -> void:
	if interrupt:
		DisplayServer.tts_stop()
	DisplayServer.tts_speak(text, voice_id)
