extends Node

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("skip_turn"):
			SignalManager.player_move.emit(Vector2.ZERO)
		if Input.is_action_just_pressed("move_left"):
			SignalManager.player_move.emit(Vector2.LEFT)
		if Input.is_action_just_pressed("move_right"):
			SignalManager.player_move.emit(Vector2.RIGHT)
		if Input.is_action_just_pressed("move_up"):
			SignalManager.player_move.emit(Vector2.UP)
		if Input.is_action_just_pressed("move_down"):
			SignalManager.player_move.emit(Vector2.DOWN)
		
		#TODO this is emiting a vector zero even if there is no user input
		
