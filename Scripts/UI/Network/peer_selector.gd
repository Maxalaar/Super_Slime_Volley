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


func update_popup_menu():
	popup_menu.clear()
	
	popup_menu.add_item(str(multiplayer.get_unique_id()))
	
	for peer in multiplayer.get_peers():
		popup_menu.add_item(str(peer))


func _on_index_pressed(index : int):
	var peer_id : int = popup_menu.get_item_text(index).to_int()
	popup_menu.title = str(peer_id)
	
	slime.slime_input_controller.set_multiplayer_authority(peer_id)
	slime.slime_input_controller.set_multiplayer_authority.rpc(peer_id)
	SignalManager.emit_slime_authority_change.rpc(peer_id, slime.name)


func _on_peer_connected(id : int):
	update_popup_menu()


func _on_peer_disconnected(id : int):
	update_popup_menu()
