extends Control
class_name PauseHandler

@export var pause_panel : Control
@export var input_selectors_container : Control
@export var input_selector_scene : PackedScene
@export var cosmetic_selector_scene : PackedScene

func _ready() -> void:
	pause_panel.hide()
	
	SignalManager.game_paused.connect(_on_game_paused)
	SignalManager.game_unpaused.connect(_on_game_unpaused)
	
	for team in PlayArea.instance.team_list:
		for i in team.slime_number:
			var container : VBoxContainer = VBoxContainer.new()
			container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			var input_selector : InputSelector = input_selector_scene.instantiate() as InputSelector
			container.add_child(input_selector)
			input_selector.label.text = team.name + " Team Slime " + str(i + 1)
			input_selector.team = team
			input_selector.slime_index = i
			
			var cosmetic_selector : CosmeticSelector = cosmetic_selector_scene.instantiate() as CosmeticSelector
			cosmetic_selector.team = team
			cosmetic_selector.slime_index = i
			container.add_child(cosmetic_selector)
			
			input_selectors_container.add_child(container)

func _on_game_paused():
	pause_panel.show()

func _on_game_unpaused():
	pause_panel.hide()
