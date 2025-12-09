extends Node2D
class_name CloudManager

@export var cloud_scene : PackedScene
@export var speed_minimum : float = 10
@export var speed_maximum : float = 15
@export var scale_minimum : float = 0.8
@export var scale_maximum : float = 1.25
@export var height_coefficient_minimum : float = 0.1
@export var height_coefficient_maximum : float = 0.4
@export var cooldown_minimum : float = 20
@export var cooldown_maximum : float = 30
@export var maximum_clouds_number : int = 5
@export var clouds_on_spawn : int = 2

var cooldown : float = 0
var cooldown_timer : float = 0
var cloud_list : Array[Node2D]

func _ready() -> void:
	cooldown = randf_range(cooldown_minimum, cooldown_maximum)
	cooldown_timer = cooldown
	
	for i in clouds_on_spawn:
		var cloud : Cloud = spawn_cloud()
		cloud.position.x = randf_range(-PlayArea.instance.level_width / 2, PlayArea.instance.level_width / 2)

func _process(delta: float) -> void:
	cooldown_timer += delta
	if cooldown_timer > cooldown:
		cooldown_timer -= cooldown
		cooldown = randf_range(cooldown_minimum, cooldown_maximum)
		spawn_cloud()

func spawn_cloud() -> Cloud:
	if cloud_list.size() >= maximum_clouds_number:
		return
	
	var cloud : Cloud = cloud_scene.instantiate() as Cloud
	add_child(cloud)
	cloud_list.append(cloud)
	cloud.destroyed.connect(_on_cloud_destroyed)
	
	cloud.speed = randf_range(speed_minimum, speed_maximum)
	
	var random_scale : float = randf_range(scale_minimum, scale_maximum)
	cloud.scale = Vector2(random_scale, random_scale)
	if randi_range(0, 1) == 0:
		cloud.scale.x *= -1
	
	var x_position : float = -PlayArea.instance.level_width / 2 - cloud.get_rect().size.x / 2
	var y_position : float = -PlayArea.instance.level_height * randf_range(height_coefficient_minimum, height_coefficient_maximum)
	cloud.global_position = Vector2(x_position, y_position)
	return cloud

func _on_cloud_destroyed(cloud : Cloud):
	cloud_list.erase(cloud)
