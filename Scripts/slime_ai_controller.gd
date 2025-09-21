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
		player_position.x,\
		player_position.y,\
		player_velocity.x,\
		player_velocity.y,\
		ball_position.x,\
		ball_position.y,\
		ball_velocity.x,\
		ball_velocity.y,\
		]
	
	return { "obs" : obs }

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size" : 3,
			"action_type" : "discrete"
		},
	}

func set_action(action) -> void:
	move_left_action = action["move_action"][0]
	move_right_action = action["move_action"][1]
	jump_action = action["move_action"][2]
