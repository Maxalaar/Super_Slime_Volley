extends Node2D
class_name SlimeEye

@export var pupil : Node2D
@export var slime : Slime

@export var pupil_movement_coefficient : float = 4

func _process(delta: float) -> void:
	move_pupil()


func move_pupil():
	var direction : Vector2 = (PlayArea.instance.ball.global_position - slime.global_position).normalized()
	pupil.global_position = global_position + direction * pupil_movement_coefficient
