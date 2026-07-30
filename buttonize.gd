extends Label

func _notification(what: int) -> void:
	if what == NOTIFICATION_ACCESSIBILITY_UPDATE:
		var ae := get_accessibility_element()
		DisplayServer.accessibility_update_set_role(ae, DisplayServer.ROLE_BUTTON)
