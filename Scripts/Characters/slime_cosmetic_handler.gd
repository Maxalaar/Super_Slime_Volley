extends Node2D
class_name SlimeCosmeticHandler

@export var behind_slime_pivot : Node2D
@export var behind_eyes_pivot : Node2D
@export var in_front_pivot : Node2D
@export var slime : Slime
@export var multiplayer_synchronizer : MultiplayerSynchronizer

@export var current_cosmetic_index : int = 0

var current_cosmetic : Sprite2D


func _init() -> void:
	SignalManager.slime_authority_change.connect(_on_slime_authority_changed)
	SignalManager.slime_cosmetic_change.connect(_on_slime_cosmetic_changed)
	
	var config : Dictionary = { 
		"rpc_mode" : MultiplayerAPI.RPCMode.RPC_MODE_ANY_PEER, 
		"transfer_mode" : MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE, 
		"call_local" : true, 
		"channel" : 0 
	}
	rpc_config("set_multiplayer_authority", config)


func _on_slime_authority_changed(peer_id : int, slime_name : String):
	if peer_id == multiplayer.get_unique_id() && slime_name == slime.name:
		set_multiplayer_authority.rpc(peer_id)
		SignalManager.emit_slime_cosmetic_name_update.rpc(slime_name, current_cosmetic_index)


func _on_slime_cosmetic_changed(target_slime : Slime, cosmetic_index : int):
	if target_slime == slime:
		set_cosmetic(cosmetic_index)


func set_cosmetic(index : int):
	current_cosmetic_index = index
	
	if current_cosmetic != null:
		current_cosmetic.queue_free()
		current_cosmetic = null
	
	if index == 0:
		return
	
	var cosmetic_scene : PackedScene = SlimeManager.instance.cosmetic_scene_list[index]
	var cosmetic : Cosmetic = cosmetic_scene.instantiate() as Cosmetic
	current_cosmetic = cosmetic
	
	match cosmetic.pivot_type:
		Cosmetic.PivotType.BehindSlime:
			behind_slime_pivot.add_child(cosmetic)
		Cosmetic.PivotType.BehindEyes:
			behind_eyes_pivot.add_child(cosmetic)
		Cosmetic.PivotType.InFront:
			in_front_pivot.add_child(cosmetic)


func _on_cosmetic_synchronized() -> void:
	set_cosmetic(current_cosmetic_index)
