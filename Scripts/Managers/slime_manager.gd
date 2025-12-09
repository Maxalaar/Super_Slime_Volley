extends Node
class_name SlimeManager

@export var cosmetic_scene_list : Array[PackedScene]

static var instance : SlimeManager

func _ready() -> void:
	instance = self
