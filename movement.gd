extends PhysicalBone2D

@export var kick_force: float = 500000.0  # Adjust based on the mass of your bone

func _ready() -> void:
	
	# Ensure custom_integrator is false so standard physics/gravity still work
	custom_integrator = false

func _physics_process(delta: float) -> void:
	# 2. Check for key press to apply the active kick force
	if Input.is_action_pressed("move_right"):
		print("test")
		# Apply a massive burst of rotational force (Torque)
		apply_torque(kick_force)
	elif Input.is_action_pressed("move_left"):
		# Kick in the opposite direction
		apply_torque(-kick_force)
