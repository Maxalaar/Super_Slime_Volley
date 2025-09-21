extends RigidBody2D
class_name Ball

@export var max_speed : float = 50

var initial_position : Vector2
var is_game_over : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	contact_monitor = true
	max_contacts_reported = 10
	
	initial_position = global_position
	
	PlayArea.game_over.connect(_on_game_over)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_game_over == true:
		global_position = initial_position
		linear_velocity = Vector2.ZERO
		is_game_over = false
	
	if linear_velocity.length() >= max_speed:
		linear_velocity = max_speed * linear_velocity.normalized()

func _on_body_entered(body : Node):
	if body is Slime:
		body.on_ball_touched()
	elif body.is_in_group("ground"):
		PlayArea.trigger_game_over()

func _on_game_over():
	is_game_over = true
