extends Node

var is_game_paused : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_settings"):
		if is_game_paused == false:
			pause_game()
		else:
			unpause_game()

func pause_game():
	Engine.time_scale = 0
	is_game_paused = true
	SignalManager.emit_game_paused()

func unpause_game():
	Engine.time_scale = 1
	is_game_paused = false
	SignalManager.emit_game_unpaused()
