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

func _notification(what: int) -> void:
	if OS.get_name() == "macOS" and what == NOTIFICATION_ACCESSIBILITY_UPDATE:
		# macOS VoiceOver doesn't realize that the text has been updated otherwise
		# We only do this for macOS, because NVDA would read the text twice
		var ae := get_accessibility_element()
		DisplayServer.accessibility_update_set_role(ae, DisplayServer.ROLE_BUTTON)
