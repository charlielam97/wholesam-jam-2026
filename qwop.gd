extends PhysicalBone2D

@export_group("QWOP Controls")
@export var input_key: Key = KEY_Q        # The specific key assigned to this limb

@export_group("Muscle Tuning")
@export var muscle_power: float = 50000.0   # Torque applied when actively pressing the key
@export var spring_strength: float = 15000.0 # Holding power when the key is released (resting)
@export var muscle_damping: float = 20.0    # Softness buffer to prevent jittering/shaking

@export_group("Joint Targets (Degrees)")
@export var rest_angle: float = 0.0          # Angle relative to parent when key is NOT pressed
@export var active_kick_angle: float = 55.0  # Angle relative to parent when key IS pressed

var parent_body: RigidBody2D = null

func _ready() -> void:
	if get_parent() is RigidBody2D:
		parent_body = get_parent()

func _physics_process(_delta: float) -> void:
	# 2. Check key state to dictate the target rotation matrix
	var is_pressing_key: bool = Input.is_key_pressed(input_key)
	var target_local_angle: float = 0.0
	
	if is_pressing_key:
		target_local_angle = deg_to_rad(active_kick_angle)
	else:
		target_local_angle = deg_to_rad(rest_angle)
		
	var current_parent_rotation: float = parent_body.global_rotation if parent_body else 0.0
	var current_local_angle: float = global_rotation - current_parent_rotation
	
	var angle_error: float = target_local_angle - current_local_angle
	angle_error = atan2(sin(angle_error), cos(angle_error))
	
	var parent_angular_vel: float = parent_body.angular_velocity if parent_body else 0.0
	var relative_velocity: float = angular_velocity - parent_angular_vel
	
	var current_strength: float = muscle_power if is_pressing_key else spring_strength
	
	var spring_torque: float = angle_error * current_strength
	var damp_torque: float = relative_velocity * muscle_damping
	apply_torque(spring_torque - damp_torque)
