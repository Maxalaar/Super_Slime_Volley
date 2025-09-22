@tool
extends Node2D
class_name PlayArea

@export var level_width : float
@export var level_height : float
@export var wall_width : float = 10

@export var wall_left : Node2D
@export var wall_right : Node2D
@export var roof : Node2D
@export var ground : Node2D

@export_tool_button("Generate Play Area") var gen_play = generate_play_area

func _ready() -> void:
	SignalManager.game_over.connect(_on_game_over)
	SignalManager.emit_reset_play_area(level_width, level_height)

func _on_game_over():
	SignalManager.emit_reset_play_area(level_width, level_height)

func generate_play_area():
	wall_left.scale = Vector2(wall_width, level_height)
	wall_right.scale = Vector2(wall_width, level_height)
	roof.scale = Vector2(level_width, wall_width)
	ground.scale = Vector2(level_width, wall_width)
	
	wall_left.global_position = Vector2(-level_width / 2 - wall_width, 0)
	wall_right.global_position = Vector2(level_width / 2 + wall_width, 0)
	roof.global_position = Vector2(0, -level_height / 2 - wall_width)
	ground.global_position = Vector2(0, level_height / 2 + wall_width)
