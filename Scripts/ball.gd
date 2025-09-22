@tool
extends RigidBody2D
class_name Ball

@export var max_speed : float = 50
@export var spawn_offset_percent_x : float = 0.1
@export var spawn_offset_percent_y : float = 0.1

@export_group("Collision Shape")
@export var collision_shape : CollisionShape2D
@export var collision_scale_factor : float
@export var collision_points_number : int
@export var color : Color
@export var polygon_2d : Polygon2D

var initial_position : Vector2
var need_position_reset : bool = false

#region Collision Shape
@export_tool_button("Generate Collision Shape") var gen_coll = generate_collision_shape

func generate_collision_shape():
	var points : Array[Vector2]
	for i in collision_points_number + 1:
		var point_position : Vector2
		var angle : float = -2 * PI * (float(i) / float(collision_points_number))
		point_position.x = collision_scale_factor * cos(angle)
		point_position.y = collision_scale_factor * sin(angle)
		points.append(point_position)
	
	var shape : ConvexPolygonShape2D = ConvexPolygonShape2D.new()
	shape.points = points
	collision_shape.shape = shape
	
	polygon_2d.polygon = points
	polygon_2d.color = color
#endregion

func _init() -> void:
	SignalManager.game_over.connect(_on_game_over)
	SignalManager.reset_play_area.connect(_on_reset_play_area)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	contact_monitor = true
	max_contacts_reported = 10
	
	initial_position = global_position

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if need_position_reset == true:
		global_position = initial_position
		linear_velocity = Vector2.ZERO
		need_position_reset = false
	
	if linear_velocity.length() >= max_speed:
		linear_velocity = max_speed * linear_velocity.normalized()

func _on_body_entered(body : Node):
	if body is Slime:
		body.on_ball_touched()
	elif body.is_in_group("ground"):
		SignalManager.emit_game_over()

func _on_game_over():
	pass

func _on_reset_play_area(width : float, height : float):
	initial_position.x = width * randf_range(-(spawn_offset_percent_x / 2), (spawn_offset_percent_x / 2))
	initial_position.y = -height / 2 + randf_range(0, spawn_offset_percent_y * height)
	global_position = initial_position
	need_position_reset = true
