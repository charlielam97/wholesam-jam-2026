extends Label

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_O) or Input.is_key_pressed(KEY_P):
		visible = false
