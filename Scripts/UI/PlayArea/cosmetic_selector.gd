extends Control
class_name CosmeticSelector

@export var popup_menu : PopupMenu

var slime : Slime

var cosmetics_dictionary : Dictionary[String, String]

func _ready() -> void:
	popup_menu.index_pressed.connect(_on_index_pressed)
	
	for cosmetic_scene in SlimeManager.instance.cosmetic_scene_list:
		var cosmetic : Cosmetic = cosmetic_scene.instantiate()
		cosmetics_dictionary[cosmetic.name] = cosmetic_scene.resource_path
		popup_menu.add_item(cosmetic.name)


func _on_index_pressed(index : int):
	var text : String = popup_menu.get_item_text(index)
	popup_menu.title = text
	
	slime.set_cosmetic(load(cosmetics_dictionary[text]))
