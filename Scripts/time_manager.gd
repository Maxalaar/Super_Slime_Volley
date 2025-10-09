extends Node

var is_game_paused : bool = false

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_settings"):
		if is_game_paused == false:
			pause_game()
		else:
			unpause_game()

func pause_game():
	get_tree().paused = true
	is_game_paused = true
	SignalManager.emit_game_paused()

func unpause_game():
	get_tree().paused = false
	is_game_paused = false
	SignalManager.emit_game_unpaused()
