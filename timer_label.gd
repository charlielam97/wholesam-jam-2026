extends Label

var time_left: float = 60.0

@export var win_manager_node: Node
@export var win_label: Label
@export var retry_button: Button 


func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		text = str(int(time_left))
	elif win_manager_node and ("is_won" in win_manager_node and not win_manager_node.is_won):
		text = "0"
		win_manager_node.is_won = true
		retry_button.visible = true

		win_label.text = "You lose :("

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
