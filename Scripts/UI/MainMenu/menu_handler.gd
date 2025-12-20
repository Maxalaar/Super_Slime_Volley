extends Node
class_name MenuHandler

@export var play_area_scene : PackedScene


func _on_single_player_button_pressed() -> void:
	get_tree().change_scene_to_packed(play_area_scene)


func _on_create_server_button_pressed() -> void:
	SignalManager.emit_server_create_start()
	get_tree().change_scene_to_packed(play_area_scene)


func _on_join_server_button_pressed() -> void:
	SignalManager.emit_server_join_start()
	get_tree().change_scene_to_packed(play_area_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
