extends AIController2D
class_name SlimeAiController

# Stores the action sampled for the agent's policy, running in python
var move_left_action : bool = false
var move_right_action : bool = false
var jump_action : bool = false

@export var ball : Ball

func get_obs() -> Dictionary:
	var player_position = _player.global_position
	var player_velocity = _player.velocity
	
	var ball_position = to_local(ball.global_position)
	var ball_velocity = to_local(ball.linear_velocity)
	
	var obs = [\
		player_position.x / 2000,\
		player_position.y / 2000,\
		player_velocity.x / 2000,\
		player_velocity.y / 2000,\
		ball_position.x / 2000,\
		ball_position.y / 2000,\
		ball_velocity.x / 2000,\
		ball_velocity.y / 2000,\
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

func set_action(action) -> void:
	move_left_action = action["move_left_action"][0] > 0
	move_right_action = action["move_right_action"][0] > 0
	jump_action = action["jump_action"][0] > 0
