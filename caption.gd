extends Label

func say(new_text: String) -> void:
	print("Saying " + new_text)
	set_caption_text(new_text)
	$CaptionTimer.start()

func set_caption_text(new_text: String):
	text = new_text
	accessibility_name = text
	
func _on_caption_timer_timeout() -> void:
	set_caption_text("")
