extends Control
class_name PeerSelector

@export var popup_menu : PopupMenu
@export var menu_bar : MenuBar

var slime : Slime


func _ready() -> void:
	popup_menu.index_pressed.connect(_on_index_pressed)
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	update_popup_menu()
	
	if multiplayer.is_server() == false:
		menu_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE


func init():
	var config : Dictionary = { 
		"rpc_mode" : MultiplayerAPI.RPCMode.RPC_MODE_ANY_PEER, 
		"transfer_mode" : MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE, 
		"call_local" : true, 
		"channel" : 0 
	}
	slime.slime_input_controller.rpc_config("set_multiplayer_authority", config)


func update_popup_menu():
	popup_menu.clear()
	
	popup_menu.add_item(str(multiplayer.get_unique_id()))
	
	for peer in multiplayer.get_peers():
		popup_menu.add_item(str(peer))


func _on_index_pressed(index : int):
	var text : String = popup_menu.get_item_text(index)
	popup_menu.title = text
	
	slime.slime_input_controller.set_multiplayer_authority(popup_menu.get_item_text(index).to_int())
	slime.slime_input_controller.set_multiplayer_authority.rpc(popup_menu.get_item_text(index).to_int())


func _on_peer_connected(id : int):
	update_popup_menu()


func _on_peer_disconnected(id : int):
	update_popup_menu()
