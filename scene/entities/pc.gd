extends Entity

var input_buffer: Array = []

func _ready() -> void:
	SignalManager.player_move.connect(_check_entity_type)
	Global.gui_manager.update_health_UI(entity_health)

func _check_entity_type(direction) -> void:
	if entity_type == entity_types.PLAYER:
		if entity_can_move:
			#input_buffer.append(direction)
			#print(direction)
			_move(direction)
			#input_buffer.clear()

func _on_entity_detection_area_2d_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity.name != 'Player':
		Global.schedule_manager.add_entities_to_order(entity)
