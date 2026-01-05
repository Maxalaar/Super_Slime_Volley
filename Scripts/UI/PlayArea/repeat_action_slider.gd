extends Slider
class_name RepeatActionSlider

@export var sync : Sync


func _init() -> void:
	SignalManager.time_scale_update.connect(_on_time_scale_updated)


func _ready() -> void:
	set_repeat_action_value(value)


func _value_changed(new_value: float) -> void:
	set_repeat_action_value(new_value)


func set_repeat_action_value(new_value : float):
	sync.action_repeat = roundi((max_value - new_value + min_value) / Engine.time_scale)
	print(sync.action_repeat)


func _on_time_scale_updated():
	set_repeat_action_value(value)
