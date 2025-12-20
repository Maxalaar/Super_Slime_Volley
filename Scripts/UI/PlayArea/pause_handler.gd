extends Control
class_name PauseHandler

@export var pause_panel : Control
@export var input_selectors_container : Control
@export var slime_settings_scene : PackedScene

func _ready() -> void:
	pause_panel.hide()
	
	SignalManager.game_paused.connect(_on_game_paused)
	SignalManager.game_unpaused.connect(_on_game_unpaused)
	
	for team in PlayArea.instance.team_list:
		for slime in team.slime_list:
			var slime_settings : SlimeSettings = slime_settings_scene.instantiate() as SlimeSettings
			slime_settings.init(slime)
			input_selectors_container.add_child(slime_settings)

func _on_game_paused():
	pause_panel.show()

func _on_game_unpaused():
	pause_panel.hide()
