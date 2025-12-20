extends Control
class_name AmbienceSelector

@export var popup_menu : PopupMenu
@export var menu_bar : MenuBar
@export var current_ambience_index : int = 0

var ambience_list : Array[PackedScene]


func _ready() -> void:
	popup_menu.index_pressed.connect(_on_index_pressed)
	
	popup_menu.add_item("None")
	ambience_list.append(null)
	
	for ambience_scene in PlayArea.instance.ambience_scene_list:
		var ambience : Node2D = ambience_scene.instantiate()
		ambience_list.append(ambience_scene)
		popup_menu.add_item(ambience.name)
	
	if multiplayer.is_server() == false:
		menu_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_index_pressed(index : int):
	var text : String = popup_menu.get_item_text(index)
	popup_menu.title = text
	
	PlayArea.instance.set_ambience(ambience_list[index])
	current_ambience_index = index


func _on_ambience_synchronized() -> void:
	_on_index_pressed(current_ambience_index)
