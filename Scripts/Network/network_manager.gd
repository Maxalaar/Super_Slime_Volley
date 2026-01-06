extends Node

const IP_ADDRESS : String = "localhost"
const PORT : int = 4206

var peer : ENetMultiplayerPeer
var ip_address : String

func _init() -> void:
	SignalManager.server_create_start.connect(start_server)
	SignalManager.server_join_start.connect(start_client)
	
	var upnp = UPNP.new()
	upnp.discover(2000, 2, "InternetGatewayDevice")
	ip_address = upnp.query_external_address()


func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer


func start_client(target_ip_address : String) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(target_ip_address, PORT)
	multiplayer.multiplayer_peer = peer
