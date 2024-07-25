extends Action
class_name MoveAction

var offset: Vector2i
var tween: Tween

#func _init(new_entity: Entity = null, dx: int = 0, dy: int = 0) -> void:
	#entity = new_entity
	#offset = Vector2i(dx, dy)

func perform() -> bool:
	if entity.entity_can_move:
		if entity.energy_component.check_energy_action(self):
			var coord: Vector2i = Global.get_coord_from_sprite(entity)
			coord += offset
			var new_coords: Vector2 = Global.get_position_from_coord(coord)
			
			Global.game_manager.astar_grid.set_point_solid(entity.position, 0)
			Global.game_manager.tile_map.set_cell(1, Global.get_coord_from_sprite(entity), 0, Vector2(-1, -1), 0)
			
			#if _check_direction(offset):
			tween = create_tween()
			tween.tween_property(entity, "position", new_coords, 0.03)
			await tween.finished
			#tween.connect("finished",Callable(self,"_turn_ended"))
			#tween.play()
			
			LogDuck.w("Tween finished", tween.is_running())
			#TODO Remove previous location from aStart and add current location
			
			#entity.position = new_coords
			Global.game_manager.astar_grid.set_point_solid(entity.position, 1)
			Global.game_manager.tile_map.set_cell(1, Global.get_coord_from_sprite(entity), 0, Vector2(32, 3), 0)
			#Global.game_manager.tile_map.set_cell(0, Global.get_coord_from_sprite(entity), 0, Vector2(32,3), 0)
			entity.energy_component.remove_energy(cost)
			
			LogDuck.d(entity.name, entity.position)
			if entity.energy_component.check_energy_empty():
				#Still have enough energy
				return true
			else:
				#Ran out of energy
				return false
		else:
			LogDuck.e("Entity: ", entity.name, " not enough energy")
			return false
	else:
		LogDuck.e("Entity: ", entity.name, " can't move")
		return false

func _check_direction(direction: Vector2) -> Object:
	var raycast_target_position = direction * Global.STEP_X
	var moveCheckRayCast2D = entity.get_node('MoveCheckRayCast2D')
	moveCheckRayCast2D.target_position = raycast_target_position
	moveCheckRayCast2D.force_raycast_update()
	var entity_collider = moveCheckRayCast2D.get_collider()
	if entity_collider == null:
		return null
	else:
		if entity_collider.name != 'TileMap' && entity_collider.name != 'EntityDetectionArea2D':
			var entity_collider_parent = entity_collider.get_parent()
			
			LogDuck.d(entity_collider_parent)
			return entity_collider_parent
		return entity_collider

#func _move(direction: Vector2i) -> void:
	#entity_can_move = false
	#print('moving: ', self.name)
	#var coord: Vector2i = Global.get_coord_from_sprite(self)
	#coord += direction
#
	#var new_coords: Vector2 = Global.get_position_from_coord(coord)
	#if _check_direction(direction):
		##tween = create_tween()
		##tween.tween_property(self, "position", new_coords, 0.1)
		##tween.connect("finished",Callable(self,"_turn_ended"))
		##tween.play()
		#position = new_coords
		#_turn_ended()
	#else: _turn_ended()
