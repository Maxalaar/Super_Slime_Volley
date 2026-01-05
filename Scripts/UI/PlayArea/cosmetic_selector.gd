extends Control
class_name CosmeticSelector

@export var popup_menu : PopupMenu
@export var current_cosmetic_index : int = 0

var slime : Slime


func _init() -> void:
	SignalManager.slime_cosmetic_name_update.connect(_on_slime_cosmetic_name_updated)


func _ready() -> void:
	popup_menu.index_pressed.connect(_on_index_pressed)

	for cosmetic_scene in SlimeManager.instance.cosmetic_scene_list:
		if cosmetic_scene == null:
			popup_menu.add_item("None")
		else:
			var cosmetic : Cosmetic = cosmetic_scene.instantiate()
			popup_menu.add_item(cosmetic.name)


func _on_index_pressed(index : int):
	var text : String = popup_menu.get_item_text(index)
	popup_menu.title = text
	
	SignalManager.emit_slime_cosmetic_change(slime, index)
	current_cosmetic_index = index


func _on_slime_cosmetic_name_updated(slime_name : String, cosmetic_index : int):
	if slime_name == slime.name:
		popup_menu.title = popup_menu.get_item_text(cosmetic_index)
