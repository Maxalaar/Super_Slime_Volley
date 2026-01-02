extends Control
class_name SlimeSettings

@export var slime_name_label : Label
@export var input_selector : InputSelector
@export var cosmetic_selector : CosmeticSelector
@export var peer_selector : PeerSelector


func init(slime : Slime):
	if slime_name_label != null:
		slime_name_label.text = slime.name
	
	if input_selector != null:
		input_selector.slime = slime
	
	if cosmetic_selector != null:
		cosmetic_selector.slime = slime
	
	if peer_selector != null:
		peer_selector.slime = slime
