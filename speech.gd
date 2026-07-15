extends Node

var voice_id := DisplayServer.tts_get_voices_for_language("en")[0]

@onready var caption := get_node("../Caption")

func say(text: String) -> void:
	caption.text = text
	$CaptionTimer.start()

func _on_caption_timer_timeout() -> void:
	caption.text = ""
