extends Resource
class_name Team

@export var slime_number : int = 0
@export var color : Color
@export var name : String
@export var weight : float = 1
@export var maximum_score : int = 3

var slime_list : Array[Slime]
var ground : Wall
var score : int = 0

func initialize():
	SignalManager.game_over.connect(_on_game_over)

func score_point():
	score += 1
	SignalManager.emit_point_scored()
	
	if score >= maximum_score:
		SignalManager.emit_game_over()

func _on_game_over():
	score = 0
	SignalManager.emit_point_scored()
