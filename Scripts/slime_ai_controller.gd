extends AIController2D
class_name SlimeAiController

# Stores the action sampled for the agent's policy, running in python
var move_left_action : bool = false
var move_right_action : bool = false
var jump_action : bool = false

var is_debug_mode : bool = false

var slime : Slime

func _init() -> void:
	SignalManager.debug_mode_start.connect(_on_debug_mode_start)

func _on_debug_mode_start():
	is_debug_mode = true

func init(player: Node2D):
	super.init(player)
	slime = _player as Slime
	onnx_model_path += slime.policy_name + ".onnx"

func _process(delta: float) -> void:
	if is_debug_mode == true || DebugManager.is_debug_started == true:
		var obs_values : Dictionary = get_obs()
		print(obs_values)
		
		for value in obs_values["obs"]:
			if value < -1 || value > 1:
				printerr("Value not between -1 and 1 !")

func get_obs() -> Dictionary:
	var obs : Array = slime.get_ai_information()
	
	obs.append_array(PlayArea.instance.ball.get_ai_information())
	
	for team_slime : Slime in slime.team.slime_list:
		if team_slime != slime:
			obs.append_array(team_slime.get_ai_information())
	
	for team : Team in PlayArea.instance.team_list:
		if team != slime.team:
			for other_slime : Slime in team.slime_list:
				obs.append_array(other_slime.get_ai_information())
	
	return { "obs" : obs }

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	#return {
		#"move_left_action" : {
			#"size" : 1,
			#"action_type" : "continuous"
		#},
		#"move_right_action" : {
			#"size" : 1,
			#"action_type" : "continuous"
		#},
		#"jump_action" : {
			#"size" : 1,
			#"action_type" : "continuous"
		#},
	#}
	
	var result : Dictionary = {
		"jump_action" : {
			"size" : 2,
			"action_type" : "discrete"
		},
		"move_left_action" : {
			"size" : 2,
			"action_type" : "discrete"
		},
		"move_right_action" : {
			"size" : 2,
			"action_type" : "discrete"
		},
	}
	
	# Actions logit are returned in alphabetical order, so we make sure actions
	# are in the same order to match logits
	result.sort()
	
	return result
	
	#return {
		#"action" : {
			#"size" : 4,
			#"action_type" : "discrete"
		#},
	#}

func set_action(action) -> void:
	#if action["action"][0] == true:
		#move_left_action = false
		#move_right_action = false
		#jump_action = false
	#elif action["action"][1] == true:
		#move_left_action = true
		#move_right_action = false
		#jump_action = false
	#elif action["action"][2] == true:
		#move_left_action = false
		#move_right_action = true
		#jump_action = false
	#elif action["action"][2] == true:
		#move_left_action = false
		#move_right_action = true
		#jump_action = false
	
	
	#move_left_action = action["move_left_action"][0] > 0
	#move_right_action = action["move_right_action"][0] > 0
	#jump_action = action["jump_action"][0] > 0
	
	move_left_action = action["move_left_action"] == 1
	move_right_action = action["move_right_action"] == 1
	jump_action = action["jump_action"] == 1
