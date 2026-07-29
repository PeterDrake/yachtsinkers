extends Node3D

@onready var yachtsinkers := get_node("../..")
@onready var level := get_node("..")

var lines
var line_index
var undiscovered_ability = load("res://sprites/undiscovered_ability.png")
var bite_unavailable = load("res://sprites/bite_unavailable.png")
var bite_available = load("res://sprites/bite_available.png")
var dive_available = load("res://sprites/dive_available.png")
var dive_unavailable = load("res://sprites/dive_unavailable.png")
var slap_available = load("res://sprites/slap_available.png")
var slap_unavailable = load("res://sprites/slap_unavailable.png")

func _ready() -> void:
	var level_number := int(level.name.substr(level.name.length() - 1))
	if level_number <= 1:
		yachtsinkers.bite_enabled = false
		yachtsinkers.ram_damage = 1
	if level_number <= 2:
		yachtsinkers.dive_enabled = false
		yachtsinkers.health_bonus = false
	yachtsinkers.slap_enabled = false
	yachtsinkers.player_speed = 250.0
	if not yachtsinkers.bite_enabled:
		$BiteIndicator.texture = undiscovered_ability
	else:
		update_indicator("bite_unavail")
	if not yachtsinkers.dive_enabled:
		$DiveIndicator.texture = undiscovered_ability
	else:
		update_indicator("dive_unavail")
	if not yachtsinkers.slap_enabled:
		$DiveIndicator.texture = undiscovered_ability
	else:
		update_indicator("slap_unavail")
	_update_health()
	restore_level()

func restore_level() -> void:
	$Caption.grab_focus()
	_update_echolocation_width()
	$Player/CollisionTimer.wait_time = 2.0 / yachtsinkers.game_speed
	$Player/WaveTimer.wait_time = 20.0 / yachtsinkers.game_speed
	$Player/SlapTimer.wait_time = 5.0 / yachtsinkers.game_speed

## Adjust the distant width of the echolocation ShapeCast
func _update_echolocation_width() -> void:
	var w = yachtsinkers.echolocation_width
	var cast = $Player/ShapeCast3D
	var a = Array(cast.shape.points)
	a[4][0] = -w
	a[5][0] = w
	a[6][0] = -w
	a[7][0] = w
	cast.shape.points = PackedVector3Array(a)

func _update_health() -> void:
	$Player.health = yachtsinkers.starting_health
	if yachtsinkers.health_bonus:
		$Player.health += 5
	
func _on_visual_hint_timer_timeout() -> void:
	$VisualHint.text = ""

func display_dialogue(this_orca_lines) -> void:
	$Caption.set_caption_text("")
	$Dialogue.focus_mode = 2
	$Caption.focus_mode = 0
	$Dialogue.show()
	$Dialogue.grab_focus()
	lines = this_orca_lines
	line_index = 0
	_display_next_line()

func _display_next_line() -> void:
	$Dialogue.text = lines[line_index]
	line_index += 1

func _on_dialogue_pressed() -> void:
	if line_index < lines.size():
		_display_next_line()
	else:
		$Dialogue.focus_mode = 0
		$Caption.set_caption_text("")
		$Caption.focus_mode = 2
		$Dialogue.hide()
		$Caption.grab_focus()

func update_indicator(ability_state: String) -> void:
	if ability_state == "bite_avail":
		$BiteIndicator.texture = bite_available
	elif ability_state == "bite_unavail":
		$BiteIndicator.texture = bite_unavailable
	elif ability_state == "dive_avail":
		$DiveIndicator.texture = dive_available
	elif ability_state == "dive_unavail":
		$DiveIndicator.texture = dive_unavailable
	elif ability_state == "slap_avail":
		$SlapIndicator.texture = slap_available
	elif ability_state == "slap_unavail":
		$SlapIndicator.texture = slap_unavailable
