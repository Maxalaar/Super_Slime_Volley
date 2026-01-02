extends Node2D

signal game_over
func emit_game_over():
	game_over.emit()

signal reset_game
func emit_reset_game(width : float, height : float):
	reset_game.emit(width, height)

signal debug_mode_start
func emit_debug_mode_start():
	debug_mode_start.emit()

signal opponents_point_scored
func emit_opponents_point_scored(team : Team):
	opponents_point_scored.emit(team)

signal point_scored
func emit_point_scored(team : Team):
	point_scored.emit(team)

signal ball_hit_ground
func emit_ball_hit_ground(ground : Wall):
	ball_hit_ground.emit(ground)

signal slime_becomes_ignored_by_balls
func emit_slime_becomes_ignored_by_balls(slime : Slime):
	slime_becomes_ignored_by_balls.emit(slime)

signal ball_hit_different_team
func emit_ball_hit_different_team():
	ball_hit_different_team.emit()

signal game_paused
func emit_game_paused():
	game_paused.emit()

signal game_unpaused
func emit_game_unpaused():
	game_unpaused.emit()

signal play_area_is_ready
func emit_play_area_is_ready():
	play_area_is_ready.emit()

signal server_create_start
func emit_server_create_start():
	server_create_start.emit()

signal server_join_start
func emit_server_join_start():
	server_join_start.emit()

signal slime_spawn(slime : Slime)
func emit_slime_spawn(slime : Slime):
	slime_spawn.emit(slime)

signal slime_destroy(slime : Slime)
func emit_slime_destroy(slime : Slime):
	slime_destroy.emit(slime)

signal slime_authority_change(peer_id : int, slime_name : String)
@rpc("authority", "call_local", "reliable")
func emit_slime_authority_change(peer_id : int, slime_name : String):
	slime_authority_change.emit(peer_id, slime_name)
