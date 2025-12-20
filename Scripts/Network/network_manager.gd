extends Node

const IP_ADDRESS : String = "localhost"
const PORT : int = 42069

var peer : ENetMultiplayerPeer

func _init() -> void:
	SignalManager.server_create_start.connect(start_server)
	SignalManager.server_join_start.connect(start_client)


func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer


func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
