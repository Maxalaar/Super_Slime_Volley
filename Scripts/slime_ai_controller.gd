extends AIController2D
class_name SlimeAiController

# Stores the action sampled for the agent's policy, running in python
var move_left_action : bool = false
var move_right_action : bool = false
var jump_action : bool = false

@export var ball : Ball
@export var play_area : PlayArea

var is_debug_mode : bool = false

func _init() -> void:
	SignalManager.debug_mode_start.connect(_on_debug_mode_start)

func _on_debug_mode_start():
	is_debug_mode = true

func _process(delta: float) -> void:
	if is_debug_mode == true:
		var obs_values : Dictionary = get_obs()
		print(obs_values)
		
		for value in obs_values["obs"]:
			if value < -1 || value > 1:
				printerr("Value not between -1 and 1 !")

func get_obs() -> Dictionary:
	var slime : Slime = _player as Slime
	
	var slime_position = _player.global_position
	var slime_velocity = _player.velocity
	
	var ball_position = ball.global_position
	var to_local_ball_position = to_local(ball.global_position)
	var ball_velocity = ball.linear_velocity
	
	var obs = [\
		slime_position.x / (play_area.level_width),\
		slime_position.y / (play_area.level_width),\
		slime_velocity.x / slime.speed,\
		slime_velocity.y / slime.jump_force,\
		ball_position.x / (play_area.level_width),\
		ball_position.y / (play_area.level_width),\
		to_local_ball_position.y / (play_area.level_width),\
		to_local_ball_position.x / (play_area.level_width),\
		ball_velocity.x / ball.max_speed,\
		ball_velocity.y / ball.max_speed,\
		]
	
	return { "obs" : obs }

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
		"move_left_action" : {
			"size" : 1,
			"action_type" : "continuous"
		},
		"move_right_action" : {
			"size" : 1,
			"action_type" : "continuous"
		},
		"jump_action" : {
			"size" : 1,
			"action_type" : "continuous"
		},
	}
	
	#return {
		#"move_left_action" : {
			#"size" : 2,
			#"action_type" : "discrete"
		#},
		#"move_right_action" : {
			#"size" : 2,
			#"action_type" : "discrete"
		#},
		#"jump_action" : {
			#"size" : 2,
			#"action_type" : "discrete"
		#},
	#}

func set_action(action) -> void:
	move_left_action = action["move_left_action"][0] > 0
	move_right_action = action["move_right_action"][0] > 0
	jump_action = action["jump_action"][0] > 0
	
	#move_left_action = action["move_left_action"][0]
	#move_right_action = action["move_right_action"][0]
	#jump_action = action["jump_action"][0]
