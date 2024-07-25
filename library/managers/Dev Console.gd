extends Control

signal mouse_event

@export var dev_console_gui: Control
@export var line_edit: LineEdit

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("dev_console"):
			dev_console_gui.visible = !dev_console_gui.visible
			get_tree().paused = dev_console_gui.visible
			await Global.wait(0.03)
			line_edit.grab_focus()
	
	if event is InputEventMouseButton:
		mouse_event.emit()

func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.clear()
	if new_text == '/generate':
		Global.game_manager.generate_world()
	if new_text == '/spawn monster':
		await mouse_event
		LogDuck.d('Mouse click', mouse_event)
		#var new_vector: Vector2i = Global.vector2_to_vector2i()
		print(get_global_mouse_position())
		print(Global.get_coord_from_coord(get_global_mouse_position()))
		print(Global.vector2_to_vector2i(Global.get_coord_from_coord(get_global_mouse_position())))
		
		print(Global.get_coord_from_sprite(Global.player))
		
		
		Global.game_manager.spawn_monster(get_global_mouse_position())
