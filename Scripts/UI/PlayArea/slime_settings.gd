extends Control
class_name SlimeSettings

@export var slime_name_label : Label
@export var input_selector : InputSelector
@export var cosmetic_selector : CosmeticSelector
@export var peer_selector : PeerSelector

var slime : Slime


func _init() -> void:
	SignalManager.slime_authority_change.connect(_on_slime_authority_changed)


func init(slime : Slime):
	self.slime = slime
	
	if slime_name_label != null:
		slime_name_label.text = slime.name
	
	if input_selector != null:
		input_selector.slime = slime
	
	if cosmetic_selector != null:
		cosmetic_selector.slime = slime
	
	if peer_selector != null:
		peer_selector.slime = slime


func _on_slime_authority_changed(peer_id : int, slime_name : String):
	if slime_name == slime.name:
		if multiplayer.is_server():
			if peer_id != multiplayer.get_unique_id():
				input_selector.hide()
				cosmetic_selector.hide()
			else:
				input_selector.show()
				cosmetic_selector.show()
		elif peer_id != multiplayer.get_unique_id():
			queue_free()
