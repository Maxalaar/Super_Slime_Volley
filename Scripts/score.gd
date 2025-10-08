extends RichTextLabel
class_name Score

var fixed_text : String = ""
var team_list : Array[Team]

func _init() -> void:
	SignalManager.game_over.connect(_on_game_over)

func set_team_list(list : Array[Team]):
	team_list = list
	update_score()

func _on_game_over():
	text = fixed_text
	for i in team_list.size():
		var team : Team = team_list[i]
		if i > 0:
			text += " -"
		
		text += " [color=#" + team.color.to_html() + "] 0[/color]"

func update_score():
	text = fixed_text
	for i in team_list.size():
		var team : Team = team_list[i]
		if i > 0:
			text += " -"
		
		text += " [color=#" + team.color.to_html() + "]" + str(team.score) + "[/color]"
