extends Slider
class_name TimeScaleSlider

var time_scale : float = 1.0


func _value_changed(new_value: float) -> void:
	Engine.time_scale = time_scale
	Engine.physics_ticks_per_second = roundi(60 * time_scale)
	time_scale = new_value
	SignalManager.emit_time_scale_update()
