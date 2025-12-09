extends StaticBody2D
class_name Wall

@export var collision_shape_2d : CollisionShape2D
@export var polygon_2d : Polygon2D

var team : Team

func _ready() -> void:
	if is_in_group("ground"):
		SignalManager.ball_hit_ground.connect(_on_ball_hit_ground)

func _on_ball_hit_ground(ground : Wall):
	if ground == self:
		ground.team.opponents_score_point()
