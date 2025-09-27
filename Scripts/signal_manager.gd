extends Node2D

signal game_over
signal reset_game
signal debug_mode_start
signal point_scored
signal ball_hit_ground

func emit_game_over():
	game_over.emit()

func emit_reset_game(width : float, height : float):
	reset_game.emit(width, height)

func emit_debug_mode_start():
	debug_mode_start.emit()

func emit_point_scored():
	point_scored.emit()

func emit_ball_hit_ground(ground : Wall):
	ball_hit_ground.emit(ground)
