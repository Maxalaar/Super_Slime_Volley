extends Node2D

signal game_over
signal reset_play_area
signal debug_mode_start

func emit_game_over():
	game_over.emit()

func emit_reset_play_area(width : float, height : float):
	reset_play_area.emit(width, height)

func emit_debug_mode_start():
	debug_mode_start.emit()
