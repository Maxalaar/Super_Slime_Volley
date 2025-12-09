extends Control
class_name InputSelector

@export var popup_menu : PopupMenu
@export var label : Label

var team : Team
var slime_index : int

func _ready() -> void:
	popup_menu.index_pressed.connect(_on_index_pressed)
	
	Input.joy_connection_changed.connect(_on_controller_changed)
	_on_controller_changed(0, true)
	
	SignalManager.play_area_is_ready.connect(_on_play_area_is_ready)


func _on_index_pressed(index : int):
	var text : String = popup_menu.get_item_text(index)
	popup_menu.title = text
	
	var slime : Slime = team.slime_list[slime_index]
	slime.set_input_mode(text)


func _on_controller_changed(device : int, connected : bool):
	for i in popup_menu.item_count:
		popup_menu.remove_item(0)
	
	for input_mode in InputManager.input_mode_list:
		popup_menu.add_item(input_mode)


func _on_play_area_is_ready():
	_on_index_pressed(0)
