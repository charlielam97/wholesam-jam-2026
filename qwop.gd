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

#@export_group("Hard Boundaries (Degrees)")
#@export var min_limit: float = -45.0        # Max backward rotation limit
#@export var max_limit: float = 70.0         # Max forward rotation limit

var target_local_angle: float = 0.0
var initial_local_rotation: float = 0.0

var parent_body: RigidBody2D = null

func _ready() -> void:
	if get_parent() is RigidBody2D:
		parent_body = get_parent()
	
	initial_local_rotation = rotation
		
	custom_integrator = false

func _physics_process(delta: float) -> void:
	var is_pressing_key: bool = Input.is_key_pressed(input_key)

	if is_pressing_key:
		target_local_angle = deg_to_rad(active_kick_angle)
	else:
		target_local_angle = deg_to_rad(rest_angle)
		
	var current_parent_rotation: float = parent_body.global_rotation
	var current_local_angle: float = global_rotation - current_parent_rotation
	
	var relative_error: float = target_local_angle - current_local_angle
	relative_error = atan2(sin(relative_error), cos(relative_error))
	
	var parent_angular_vel: float = parent_body.angular_velocity
	var relative_velocity: float = angular_velocity - parent_angular_vel
	
	if is_pressing_key:
		apply_torque(relative_error * muscle_power - relative_velocity * muscle_damping)
	else:
		apply_torque(relative_error * spring_strength - relative_velocity * muscle_damping)
	
