extends Area2D

var is_won: bool = false

@export var win_label: Label

func _on_horse_part_entered(body: Node2D) -> void:
	print("You won at life!!!")
	
	is_won = true
	
	win_label.text = "YOU WON!!!"
	
	var scene_root: Window = get_tree().root
	var skeleton: Skeleton2D = _find_skeleton_anywhere(scene_root)
	
	if skeleton:
		_remove_joints_under(skeleton)
		print("Successfully broke all physical joint constraints on: ", skeleton.name)
	else:
		push_error("CRITICAL: Skeleton2D could not be found anywhere in the active game scene!")

func _ready() -> void:
	body_entered.connect(_on_horse_part_entered)

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
