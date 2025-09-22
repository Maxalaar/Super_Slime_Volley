extends Node2D

signal game_over
signal reset_play_area

func emit_game_over():
	game_over.emit()

func emit_reset_play_area(width : float, height : float):
	reset_play_area.emit(width, height)
