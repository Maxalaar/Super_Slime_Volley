extends Node2D

signal game_over
signal reset_game
signal debug_mode_start
signal opponents_point_scored
signal point_scored
signal ball_hit_ground
signal slime_becomes_ignored_by_balls
signal ball_hit_different_team
signal game_paused
signal game_unpaused
signal play_area_is_ready

func emit_game_over():
	game_over.emit()

func emit_reset_game(width : float, height : float):
	reset_game.emit(width, height)

func emit_debug_mode_start():
	debug_mode_start.emit()

func emit_opponents_point_scored(team : Team):
	opponents_point_scored.emit(team)

func emit_point_scored(team : Team):
	point_scored.emit(team)

func emit_ball_hit_ground(ground : Wall):
	ball_hit_ground.emit(ground)

func emit_slime_becomes_ignored_by_balls(slime : Slime):
	slime_becomes_ignored_by_balls.emit(slime)

func emit_ball_hit_different_team():
	ball_hit_different_team.emit()

func emit_game_paused():
	game_paused.emit()

func emit_game_unpaused():
	game_unpaused.emit()

func emit_play_area_is_ready():
	play_area_is_ready.emit()
