extends StaticBody2D # Or TileMapLayer depending on your setup

func _ready() -> void:
	# 1. Add the floor to the floor group so your QWOP scripts still know it
	add_to_group("floor")
	
	# 2. Programmatically create an Area2D around the floor to catch the horse's head
	var global_detector = Area2D.new()
	global_detector.name = "HorseHeadDetector"
	add_child(global_detector)
	
	# Copy the floor's collision shape so it matches the ground perfectly
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			var duplicate_shape = child.duplicate()
			global_detector.add_child(duplicate_shape)
			
	global_detector.set_collision_layer_value(1, true)
	global_detector.set_collision_mask_value(1, false)
	global_detector.set_collision_mask_value(2, false)
	global_detector.set_collision_mask_value(3, true)
	
	global_detector.body_entered.connect(_on_horse_part_entered)

func _on_horse_part_entered(body: Node2D) -> void:
	print("Restarting due to ", body.name, " crashed!")
	get_tree().reload_current_scene()
