extends Control
class_name PauseHandler

@export var pause_panel : Control
@export var input_selectors_container : Control
@export var slime_settings_scene : PackedScene
@export var slime_settings_client_scene : PackedScene
@export var hide_if_client_list : Array[Control]


func _init() -> void:
	SignalManager.slime_authority_change.connect(_on_slime_authority_changed)


func _ready() -> void:
	pause_panel.hide()
	
	SignalManager.game_paused.connect(_on_game_paused)
	SignalManager.game_unpaused.connect(_on_game_unpaused)
	
	if multiplayer.is_server():
		for team in PlayArea.instance.team_list:
			for slime in team.slime_list:
				create_slime_settings(slime, slime_settings_scene)
	
	if multiplayer.is_server() == false:
		for control in hide_if_client_list:
			control.hide()


func create_slime_settings(slime : Slime, scene : PackedScene):
	var slime_settings : SlimeSettings = scene.instantiate() as SlimeSettings
	slime_settings.init(slime)
	input_selectors_container.add_child(slime_settings)


func _on_game_paused():
	pause_panel.show()


func _on_game_unpaused():
	pause_panel.hide()


func _on_slime_authority_changed(peer_id : int, slime_name : String):
	if multiplayer.is_server() == false && peer_id == multiplayer.get_unique_id():
		create_slime_settings(SlimeManager.instance.name_to_slime[slime_name], slime_settings_client_scene)
