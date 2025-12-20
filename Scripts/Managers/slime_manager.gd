extends Node
class_name SlimeManager

@export var cosmetic_scene_list : Array[PackedScene]

static var instance : SlimeManager

var name_to_slime : Dictionary[String, Slime]


func _init() -> void:
	instance = self
	
	SignalManager.slime_spawn.connect(_on_slime_spawned)


func _on_slime_spawned(slime : Slime):
	name_to_slime[slime.name] = slime


@rpc("any_peer", "call_local", "reliable")
func send_inputs_to_server(peer_id : int, slime_name : String, is_moving_left : bool,\
	is_moving_right : bool, is_jumping : bool):
	
	if name_to_slime.keys().has(slime_name):
		var slime : Slime = name_to_slime[slime_name]
		if slime.slime_input_controller.get_multiplayer_authority() == peer_id:
			slime.move(is_moving_left, is_moving_right, is_jumping)
