extends Node

var voice_id := DisplayServer.tts_get_voices_for_language("en")[0]

@onready var caption := get_node("../Caption")

func say(text: String) -> void:
	print("Saying " + text)
	set_caption_text(text)
	$CaptionTimer.start()

func set_caption_text(text: String):
	caption.text = text
	caption.accessibility_name = text
	
func _on_caption_timer_timeout() -> void:
	set_caption_text("")
