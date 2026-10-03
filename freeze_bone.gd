extends PhysicalBone2D

@onready var target_bone: Bone2D = get_node(bone2d_nodepath) as Bone2D
var constant_local_rotation: float

func _ready() -> void:
	if target_bone:
		constant_local_rotation = target_bone.rotation
	
	# Enable physics tracking for this piece
	self.simulate_physics = true

func _physics_process(_delta: float) -> void:
	if target_bone:
		# Prevent the bone from twisting locally during ragdoll movement
		target_bone.rotation = constant_local_rotation
