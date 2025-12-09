extends Control
class_name AmbienceSelector

@export var popup_menu : PopupMenu

var ambience_list : Array[PackedScene]


func _ready() -> void:
	popup_menu.index_pressed.connect(_on_index_pressed)
	
	for ambience_scene in PlayArea.instance.ambience_scene_list:
		var ambience : Node2D = ambience_scene.instantiate()
		ambience_list.append(ambience_scene)
		popup_menu.add_item(ambience.name)
	
	popup_menu.add_item("None")


func _on_index_pressed(index : int):
	var text : String = popup_menu.get_item_text(index)
	popup_menu.title = text
	
	if index >= ambience_list.size():
		PlayArea.instance.set_ambience(null)
	else:
		PlayArea.instance.set_ambience(ambience_list[index])
