extends Node
class_name SlimeInputController

@export var slime : Slime


func _process(delta: float) -> void:
	update_inputs()


func update_inputs():
	if is_multiplayer_authority() == false:
		return
	
	if slime.gamepad_index == -1:
		if slime.input_mode == "Keyboard ZQSD":
			SlimeManager.instance.rpc_id(1, "send_inputs_to_server", multiplayer.get_unique_id(), slime.name,\
				Input.is_action_pressed("zqsd_move_left"),\
				Input.is_action_pressed("zqsd_move_right"),\
				Input.is_action_pressed("zqsd_jump"))
		elif slime.input_mode == "Keyboard Arrows":
			SlimeManager.instance.rpc_id(1, "send_inputs_to_server", multiplayer.get_unique_id(), slime.name,\
				Input.is_action_pressed("arrows_move_left"),\
				Input.is_action_pressed("arrows_move_right"),\
				Input.is_action_pressed("arrows_jump"))
		elif slime.input_mode == "AI":
			SlimeManager.instance.rpc_id(1, "send_inputs_to_server", multiplayer.get_unique_id(), slime.name,\
				slime.ai_controller.move_left_action,\
				slime.ai_controller.move_right_action,\
				slime.ai_controller.jump_action)
	else:
		SlimeManager.instance.rpc_id(1, "send_inputs_to_server", multiplayer.get_unique_id(), slime.name,\
			InputManager.is_gamepad_moving_left(slime.gamepad_index),\
			InputManager.is_gamepad_moving_right(slime.gamepad_index),\
			InputManager.is_gamepad_jumping(slime.gamepad_index))
