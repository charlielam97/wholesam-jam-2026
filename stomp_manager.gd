extends AudioStreamPlayer

@export var move_threshold: float = 0.5
@export var min_pitch: float = 0.6
@export var max_pitch: float = 1.8
@export var speed_scale: float = 0.1
@export var stop_delay: float = 0.2
@export var player: Node2D = null
@export var win_manager_node: Node

var last_x: float = 0.0
var delay_timer: float = 0.0

func _process(delta: float) -> void:
	if win_manager_node and ("is_won" in win_manager_node and win_manager_node.is_won):
		volume_db = -80.0
		
	if not player:
		return

	var speed: float = abs(player.global_position.x - last_x)
	last_x = player.global_position.x
	
	if speed > move_threshold:
		delay_timer = stop_delay
		
		volume_db = 0.0
		
		var target_pitch: float = lerp(min_pitch, max_pitch, speed * speed_scale)
		pitch_scale = clamp(target_pitch, min_pitch, max_pitch)
	else:
		if delay_timer > 0:
			delay_timer -= delta
			volume_db = 0.0
			var target_pitch: float = lerp(min_pitch, max_pitch, speed * speed_scale)
			pitch_scale = clamp(target_pitch, min_pitch, max_pitch)
		else:
			volume_db = -80.0
