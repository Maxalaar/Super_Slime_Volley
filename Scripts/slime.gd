extends CharacterBody2D
class_name Slime

@export var speed : float = 10
@export var jump_force : float = 500
@export var spawn_offset_percent_x : float = 0.1
@export var maximum_ball_touch_number : int = 2
@export_range(0, 1) var transparency_minimum : float = 0.1
@export_range(0, 1) var transparency_maximum : float = 1

@export var behind_eyes_pivot : Node2D
@export var front_eyes_pivot : Node2D

@export_group("Collision Shape")
@export var collision_shape : CollisionShape2D
@export var size : float
@export var collision_points_number : int
@export var color : Color
@export var polygon_2d : Polygon2D

@export_group("AI Controller")
@export var ai_controller : SlimeAiController

var is_on_ground : bool = false
var initial_position : Vector2
var team : Team
var current_ball_touch_number : int = 0

var input_mode : String
var gamepad_index : int = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_cosmetic : Sprite2D

#region Collision Shape
#@export_tool_button("Generate Collision Shape") var gen_coll = generate_collision_shape

func generate_collision_shape():
	var points : Array[Vector2]
	for i in collision_points_number + 1:
		var point_position : Vector2
		var angle : float = -PI * (float(i) / float(collision_points_number))
		point_position.x = size * cos(angle)
		point_position.y = size * sin(angle)
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
	SignalManager.ball_hit_different_team.connect(_on_ball_hit_different_team)

func _ready() -> void:
	generate_collision_shape()
	
	ai_controller.init(self)
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

func set_input_mode(input_mode : String):
	self.input_mode = input_mode
	
	if input_mode.split(" ")[-1].is_valid_int():
		gamepad_index = input_mode.split(" ")[-1].to_int() - 1
	else:
		gamepad_index = -1

func update_inputs():
	velocity.x = 0
	
	if gamepad_index == -1:
		if input_mode == "Keyboard ZQSD":
			move(Input.is_action_pressed("zqsd_move_left"),\
				Input.is_action_pressed("zqsd_move_right"),\
				Input.is_action_pressed("zqsd_jump"))
		elif input_mode == "Keyboard Arrows":
			move(Input.is_action_pressed("arrows_move_left"),\
				Input.is_action_pressed("arrows_move_right"),\
				Input.is_action_pressed("arrows_jump"))
		elif input_mode == "AI":
			move(ai_controller.move_left_action,\
				ai_controller.move_right_action,\
				ai_controller.jump_action)
	else:
		move(InputManager.is_gamepad_moving_left(gamepad_index),\
			InputManager.is_gamepad_moving_right(gamepad_index),\
			InputManager.is_gamepad_jumping(gamepad_index))

func move(is_moving_left : bool, is_moving_right : bool, is_jumping : bool):
	if is_moving_left:
		velocity.x = -speed
	if is_moving_right:
		velocity.x = speed
	if is_jumping:
		jump()

func jump():
	if is_on_ground == false:
		return
	
	velocity.y = -jump_force
	
func on_ball_touched(ball : Ball):
	current_ball_touch_number += 1
	update_transparency()
	if current_ball_touch_number >= maximum_ball_touch_number:
		SignalManager.emit_slime_becomes_ignored_by_balls(self)

func reset_ball_touch():
	current_ball_touch_number = 0
	update_transparency()

func update_transparency():
	polygon_2d.color.a = transparency_minimum + (transparency_maximum - transparency_minimum) * (1 - float(current_ball_touch_number) / float(maximum_ball_touch_number))

func _on_game_over():
	ai_controller.done = true
	ai_controller.reset()

func _on_reset_game(width : float, height : float):
	var random_factor : float = randf_range(-1, 1)
	initial_position.x = team.ground.global_position.x + random_factor * 2 * team.ground.scale.x * (spawn_offset_percent_x / 2) - (sign(random_factor) * size)
	initial_position.y = height / 2
	velocity = Vector2.ZERO
	global_position = initial_position
	reset_ball_touch()

func _on_ball_hit_different_team():
	reset_ball_touch()

func get_ai_information() -> Array:
	var slime_position = global_position
	var slime_velocity = velocity
	
	var play_area : PlayArea = PlayArea.instance
	
	var information : Array = [\
		slime_position.x / (play_area.level_width),\
		slime_position.y / (play_area.level_height),\
		slime_velocity.x / speed,\
		slime_velocity.y / jump_force,\
		float(current_ball_touch_number) / float(maximum_ball_touch_number),\
		float(play_area.team_list.find(team)) / float(play_area.team_list.size()),\
		float(team.score) / float(team.maximum_score),\
		]
	
	return information

func set_cosmetic(cosmetic_scene : PackedScene):
	if current_cosmetic != null:
		current_cosmetic.queue_free()
	
	var cosmetic : Cosmetic = cosmetic_scene.instantiate() as Cosmetic
	current_cosmetic = cosmetic
	
	if cosmetic.is_behind_eyes == true:
		behind_eyes_pivot.add_child(cosmetic)
	else:
		front_eyes_pivot.add_child(cosmetic)
