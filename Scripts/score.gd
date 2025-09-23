extends Label
class_name Score

var fixed_text : String = "Score : "
var score : int = 0

func _init() -> void:
	SignalManager.point_scored.connect(_on_point_scored)
	SignalManager.reset_game.connect(_on_reset_game)

func _on_point_scored():
	score += 1
	text = fixed_text + str(score)

func _on_reset_game(width : float, height : float):
	score = 0
	text = fixed_text + str(score)
