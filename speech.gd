extends Node

var voice_id := DisplayServer.tts_get_voices_for_language("en")[0]

@onready var caption := get_node("/root/YachtSinkers/UI/Caption")

func say(text: String) -> void:
	caption.text = text
