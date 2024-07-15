extends Node

func _input(event):
	var direction = Vector2.ZERO
	if event is InputEventKey:
		if Input.is_action_just_pressed("skip_turn"):
			direction = Vector2.ZERO
		if Input.is_action_pressed("move_left"):
			direction = Vector2.LEFT
		if Input.is_action_pressed("move_right"):
			direction = Vector2.RIGHT
		if Input.is_action_pressed("move_up"):
			direction = Vector2.UP
		if Input.is_action_pressed("move_down"):
			direction = Vector2.DOWN
		
		SignalManager.player_move.emit(direction)
