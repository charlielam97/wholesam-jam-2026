extends AudioStreamPlayer

@export var sound_list: Array[AudioStream] = []

@export var win_manager_node: Node

var played = false

func _process(_delta: float) -> void:
	if not played and (win_manager_node and ("is_won" in win_manager_node and win_manager_node.is_won)):
		played = true
		play_random_sound()

func play_random_sound() -> void:
	if sound_list.is_empty():
		return
		
	stream = sound_list.pick_random()
	play()
