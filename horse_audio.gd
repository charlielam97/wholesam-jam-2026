extends Node

@export var win_manager_node: Node
@export var play_volume_db: float = 0.0
@export var sound_duration: float = 0.75  # How long the sound plays before fading out
@export var fade_speed: float = 60.0     # How fast the volume drops (dB per second)

var played: bool = false
var audio_channels: Array[AudioStreamPlayer] = []
var active_channel: AudioStreamPlayer = null
var duration_timer: float = 0.0

func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			audio_channels.append(child)
			child.volume_db = -80.0

func _process(delta: float) -> void:
	if not played and (win_manager_node and ("is_won" in win_manager_node and win_manager_node.is_won)):
		played = true
		play_random_sound()
		
	if played and active_channel:
		if duration_timer > 0.0:
			duration_timer -= delta
		else:
			active_channel.volume_db = move_toward(active_channel.volume_db, -80.0, fade_speed * delta)
			if active_channel.volume_db <= -79.9:
				active_channel = null

func play_random_sound() -> void:
	if audio_channels.is_empty():
		return
		
	active_channel = audio_channels.pick_random()
	active_channel.volume_db = play_volume_db
	duration_timer = sound_duration
