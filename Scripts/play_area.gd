extends Node2D

signal game_over

func trigger_game_over():
	game_over.emit()
