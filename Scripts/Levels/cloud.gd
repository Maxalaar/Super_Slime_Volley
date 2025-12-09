extends Sprite2D
class_name Cloud

@export var speed : float = 10

signal destroyed

func _process(delta: float) -> void:
	global_position = global_position + Vector2(speed * delta, 0)
	
	if global_position.x > PlayArea.instance.level_width / 2 + get_rect().size.x / 2:
		destroyed.emit(self)
		queue_free()
