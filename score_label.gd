extends Label

@export var player : RigidBody2D
@export var win_manager_node: Node

var score = 0

func _physics_process(_delta):
	if win_manager_node and ("is_won" in win_manager_node and not win_manager_node.is_won):
		score = round(player.position.x) / 100
		text = "%s" % score
