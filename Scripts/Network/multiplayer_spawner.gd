extends MultiplayerSpawner

@export var scene : PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_scene)


func spawn_scene(id : int):
	if multiplayer.is_server() == false:
		return
	
	var node : Slime = scene.instantiate()
	node.name = str(id)
	get_node(spawn_path).call_deferred("add_child", node)
