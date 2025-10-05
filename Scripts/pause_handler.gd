extends Control
class_name PauseHandler

@export var pause_panel : Control
@export var input_selectors_container : Control
@export var input_selector_scene : PackedScene

func _ready() -> void:
	pause_panel.hide()
	
	SignalManager.game_paused.connect(_on_game_paused)
	SignalManager.game_unpaused.connect(_on_game_unpaused)
	
	for team in PlayArea.instance.team_list:
		for i in team.slime_number:
			var input_selector : InputSelector = input_selector_scene.instantiate() as InputSelector
			input_selectors_container.add_child(input_selector)
			input_selector.label.text = team.name + " Team Slime " + str(i + 1)
			input_selector.team = team
			input_selector.slime_index = i

func _on_game_paused():
	pause_panel.show()

func _on_game_unpaused():
	pause_panel.hide()
