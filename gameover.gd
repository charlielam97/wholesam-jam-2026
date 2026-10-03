extends StaticBody2D # Or TileMapLayer depending on your setup

@export var win_manager_node: Node
@export var win_label: Label
@export var retry_button: Button 

func _ready() -> void:
	add_to_group("floor")
	
	var global_detector = Area2D.new()
	global_detector.name = "HorseHeadDetector"
	add_child(global_detector)
	
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
	if win_manager_node and ("is_won" in win_manager_node and not win_manager_node.is_won):
		print("Restarting due to ", body.name, " crashed!")
		#get_tree().reload_current_scene()
		
		win_label.text = "ded (†_†)"
		
		win_manager_node.is_won = true
		retry_button.visible = true
		
		var scene_root: Window = get_tree().root
		var skeleton: Skeleton2D = _find_skeleton_anywhere(scene_root)

		if skeleton:
			_remove_joints_under(skeleton)
			print("Successfully broke all physical joint constraints on: ", skeleton.name)
		else:
			push_error("CRITICAL: Skeleton2D could not be found anywhere in the active game scene!")

func _find_skeleton_anywhere(current_node: Node) -> Skeleton2D:
	if current_node is Skeleton2D:
		return current_node
	for child in current_node.get_children():
		var found = _find_skeleton_anywhere(child)
		if found:
			return found
	return null

func _remove_joints_under(current_node: Node) -> void:
	for child in current_node.get_children():
		if child is Joint2D:
			child.queue_free()
		else:
			_remove_joints_under(child)
