extends Node
class_name DebugManager

@export var is_debug_mode : bool = true

static var is_debug_started : bool = false

func _ready() -> void:
	if is_debug_mode == true:
		SignalManager.emit_debug_mode_start()
		is_debug_started = true
