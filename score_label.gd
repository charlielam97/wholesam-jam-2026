extends Label

@export var player : RigidBody2D

var score = 0

func _physics_process(_delta):
	score = round(player.position.x) / 100
	text = "Score: %s" % score
