extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/Caption.grab_focus()
	get_tree().root.size_changed.connect(on_viewport_size_changed)
	on_viewport_size_changed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_viewport_size_changed() -> void:
	print(get_viewport().get_visible_rect().size.x)
	$UI/Caption.custom_maximum_size = Vector2(get_viewport().get_visible_rect().size.x - 100, -1)
	#$Caption.custom_maximum_size = Vector2(1000, 100)
	pass
