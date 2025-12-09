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
	SignalManager.opponents_point_scored.connect(_on_opponents_point_scored)

func opponents_score_point():
	SignalManager.emit_opponents_point_scored(self)
	
	for slime in slime_list:
		slime.ai_controller.reward -= 1

func score_point():
	score += 1
	SignalManager.emit_point_scored(self)
	
	for slime in slime_list:
		slime.ai_controller.reward += 1
	
	if score >= maximum_score:
		SignalManager.emit_game_over()

func _on_game_over():
	score = 0
	SignalManager.emit_point_scored(self)

func _on_opponents_point_scored(team : Team):
	if team != self:
		score_point()
