@tool
extends RigidBody2D
class_name Ball

@export var initial_max_speed : float = 50
@export var max_speed_increment : float = 20
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
var current_max_speed : float
var last_position : Vector2

var last_slime_touched : Slime

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
	SignalManager.reset_game.connect(_on_reset_game)
	SignalManager.slime_becomes_ignored_by_balls.connect(_on_slime_becomes_ignored_by_balls)
	SignalManager.ball_hit_different_team.connect(_on_ball_hit_different_team)
	
	current_max_speed = initial_max_speed
	last_position = global_position

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	contact_monitor = true
	max_contacts_reported = 10
	
	initial_position = global_position

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if need_position_reset == true:
		global_position = initial_position
		current_max_speed = initial_max_speed
		var direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		linear_velocity = current_max_speed * direction * randf_range(0.0, 1.0)
		need_position_reset = false
		reset_collision_exceptions()
	
	if linear_velocity.length() >= current_max_speed:
		linear_velocity = current_max_speed * linear_velocity.normalized()

func _physics_process(delta: float) -> void:
	last_position = global_position

func get_ai_information() -> Array:
	var play_area : PlayArea = PlayArea.instance

	var ball_position = global_position
	var ball_velocity = linear_velocity
	
	return [\
		ball_position.x / (play_area.level_width),\
		ball_position.y / (play_area.level_height),\
		ball_velocity.x / current_max_speed,\
		ball_velocity.y / current_max_speed,\
		last_position.x / (play_area.level_width),\
		last_position.y / (play_area.level_height),\
		(global_position.x - last_position.x) / (play_area.level_width),\
		(global_position.y - last_position.y) / (play_area.level_height),\
	]

func _on_body_entered(body : Node):
	if body is Slime:
		if last_slime_touched != null && body.team != last_slime_touched.team:
			SignalManager.emit_ball_hit_different_team()
			current_max_speed += max_speed_increment
		
		body.on_ball_touched(self)
		last_slime_touched = body as Slime
	elif body.is_in_group("ground") && body is Wall:
		SignalManager.emit_ball_hit_ground(body as Wall)

func _on_game_over():
	pass

func _on_reset_game(width : float, height : float):
	initial_position.x = width * randf_range(-(spawn_offset_percent_x / 2), (spawn_offset_percent_x / 2))
	initial_position.y = -height / 2 + randf_range(0, spawn_offset_percent_y * height)
	global_position = initial_position
	need_position_reset = true

func _on_slime_becomes_ignored_by_balls(slime : Slime):
	add_collision_exception_with(slime)

func _on_ball_hit_different_team():
	reset_collision_exceptions()

func reset_collision_exceptions():
	for body in get_collision_exceptions():
		remove_collision_exception_with(body)
