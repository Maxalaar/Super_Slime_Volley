extends CharacterBody2D
class_name Slime

@export var speed : float = 10
@export var push_force : float = 80
@export var jump_force : float = 500

@export_group("Collision Shape")
@export var collision_shape : CollisionShape2D
@export var collision_scale_factor : float
@export var collision_points_number : int
@export var color : Color
@export var polygon_2d : Polygon2D

@export_group("AI Controller")
@export var ai_controller : SlimeAiController

var is_on_ground : bool = false
var initial_position : Vector2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#region Collision Shape
#@export_tool_button("Generate Collision Shape") var gen_coll = generate_collision_shape

func generate_collision_shape():
	var points : Array[Vector2]
	for i in collision_points_number + 1:
		var point_position : Vector2
		var angle : float = -PI * (float(i) / float(collision_points_number))
		point_position.x = collision_scale_factor * cos(angle)
		point_position.y = collision_scale_factor * sin(angle)
		points.append(point_position)
	
	var shape : ConvexPolygonShape2D = ConvexPolygonShape2D.new()
	shape.points = points
	collision_shape.shape = shape
	
	polygon_2d.polygon = points
	polygon_2d.color = color
#endregion

func _ready() -> void:
	ai_controller.init(self)
	
	PlayArea.game_over.connect(_on_game_over)
	initial_position = global_position

func _process(delta: float) -> void:
	update_inputs()

func _physics_process(delta: float) -> void:
	rotation_degrees = 0
	
	velocity.y += gravity * delta
	
	move_and_slide()
	
	is_on_ground = false
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var node : Node = collision.get_collider() as Node
		if node:
			if node.is_in_group("ground"):
				is_on_ground = true

func update_inputs():
	velocity.x = 0
	
	if ai_controller.heuristic == "human":
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		if Input.is_action_pressed("jump"):
			jump()
	else:
		if ai_controller.move_left_action:
			velocity.x = -speed
		if ai_controller.move_right_action:
			velocity.x = speed
		if ai_controller.jump_action:
			jump()

func jump():
	if is_on_ground == false:
		return
	
	velocity.y = -jump_force

func on_ball_touched():
	ai_controller.reward += 1

func _on_game_over():
	ai_controller.done = true
	ai_controller.reset()
	velocity = Vector2.ZERO
	global_position = initial_position
