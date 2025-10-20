@tool
extends Node2D
class_name PlayArea

static var instance : PlayArea

@export var ball : Ball
@export var score : Score

@export_group("Slimes")
@export var team_list : Array[Team]
@export var slime_scene : PackedScene

@export_group("Level")
@export var level_width : float
@export var level_height : float
@export var wall_width : float = 10
@export var net_width : float = 10
@export var net_height : float = 10

@export var walls_container : Node2D
@export var wall_left : Node2D
@export var wall_right : Node2D
@export var roof : Node2D
@export var ground_scene : PackedScene
@export var net_scene : PackedScene


@export_tool_button("Generate Play Area") var gen_play = generate_play_area

var ground_list : Array[Wall]
var net_list : Array[Node2D]

func _init() -> void:
	instance = self

func _ready() -> void:
	SignalManager.game_over.connect(_on_game_over)
	SignalManager.point_scored.connect(_on_point_scored)
	
	generate_play_area()
	spawn_slimes()
	
	score.set_team_list(team_list)
	
	SignalManager.emit_reset_game(level_width, level_height)
	
	for team : Team in team_list:
		team.initialize()
	
	SignalManager.emit_play_area_is_ready()


func _on_game_over():
	SignalManager.emit_reset_game(level_width, level_height)
	score.update_score()

func _on_point_scored(team : Team):
	SignalManager.emit_reset_game(level_width, level_height)
	score.update_score()

func generate_play_area():
	wall_left.scale = Vector2(wall_width, level_height)
	wall_right.scale = Vector2(wall_width, level_height)
	roof.scale = Vector2(level_width, wall_width)
	
	wall_left.global_position = Vector2(-level_width / 2 - wall_width, 0)
	wall_right.global_position = Vector2(level_width / 2 + wall_width, 0)
	roof.global_position = Vector2(0, -level_height / 2 - wall_width)
	
	var weights_sum : float = 0
	for team : Team in team_list:
		weights_sum += team.weight
	
	var last_position_x : float = -level_width / 2
	var last_position_y : float = level_height / 2 + wall_width
	for i in team_list.size():
		var team : Team = team_list[i]
		var ground : Wall = ground_scene.instantiate()
		ground.add_to_group("ground")
		walls_container.add_child(ground)
		
		ground.scale = Vector2(level_width * 0.5 * team.weight / weights_sum, wall_width)
		ground.global_position = Vector2(last_position_x + ground.scale.x, last_position_y)
		last_position_x += 2 * ground.scale.x
		
		team.ground = ground
		ground.team = team
		ground.polygon_2d.color = team.color
		ground_list.append(ground)
		
		if i != team_list.size() - 1:
			var net : Node2D = net_scene.instantiate()
			walls_container.add_child(net)
			
			net.scale = Vector2(net_width, net_height)
			net.global_position = Vector2(last_position_x, level_height / 2 - net_height)
			
			net_list.append(net)

func spawn_slimes():
	for team : Team in team_list:
		for i in team.slime_number:
			var slime : Slime = slime_scene.instantiate() as Slime
			slime.team = team
			slime.ai_controller.policy_name = team.name.to_snake_case() + '_' + str(i)
			team.slime_list.append(slime)
			
			add_child(slime)
			slime.polygon_2d.color = team.color
