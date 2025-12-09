extends Node

@export var gamepad_deadzone_x : float = 0.2
@export var gamepad_deadzone_y : float = 0.5

var controller_list : Array[int]
var input_mode_list : Array[String]

func _ready() -> void:
	detect_controllers(0, true)
	
	Input.joy_connection_changed.connect(detect_controllers)


func detect_controllers(device : int, connected : bool):
	controller_list.clear()
	
	input_mode_list = ["AI", "Keyboard ZQSD", "Keyboard Arrows"]
	
	for controller in Input.get_connected_joypads():
		controller_list.append(controller)
		input_mode_list.append("Gamepad " + str((controller + 1)))
		print("Controller index " + str(controller) + " : " + Input.get_joy_name(controller))
	
	print(input_mode_list)


func is_gamepad_moving_left(gamepad_index : int) -> bool:
	return Input.get_joy_axis(gamepad_index, JOY_AXIS_LEFT_X) < -gamepad_deadzone_x\
	|| Input.get_joy_axis(gamepad_index, JOY_AXIS_RIGHT_X) < -gamepad_deadzone_x\
	|| Input.get_joy_axis(gamepad_index, JOY_AXIS_TRIGGER_LEFT) > 0\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_DPAD_LEFT)\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_LEFT_SHOULDER)


func is_gamepad_moving_right(gamepad_index : int) -> bool:
	return Input.get_joy_axis(gamepad_index, JOY_AXIS_LEFT_X) > gamepad_deadzone_x\
	|| Input.get_joy_axis(gamepad_index, JOY_AXIS_RIGHT_X) > gamepad_deadzone_x\
	|| Input.get_joy_axis(gamepad_index, JOY_AXIS_TRIGGER_RIGHT) > 0\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_DPAD_RIGHT)\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_RIGHT_SHOULDER)


func is_gamepad_jumping(gamepad_index : int) -> bool:
	return Input.get_joy_axis(gamepad_index, JOY_AXIS_LEFT_Y) < -gamepad_deadzone_y\
	|| Input.get_joy_axis(gamepad_index, JOY_AXIS_RIGHT_Y) < -gamepad_deadzone_y\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_DPAD_UP)\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_A)\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_B)\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_X)\
	|| Input.is_joy_button_pressed(gamepad_index, JOY_BUTTON_Y)
