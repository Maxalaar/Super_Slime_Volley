extends Slider
class_name TimeScaleSlider

var time_scale : float = 1.0

func _ready() -> void:
	SignalManager.game_unpaused.connect(_on_game_unpaused)

func _value_changed(new_value: float) -> void:
	time_scale = new_value

func _on_game_unpaused():
	Engine.physics_ticks_per_second = roundi(time_scale * 60)
	Engine.time_scale = time_scale
