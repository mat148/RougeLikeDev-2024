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
			
			#if _check_direction(offset):
				#tween = create_tween()
				#tween.tween_property(entity, "position", new_coords, 0.03)
				#await tween.finished
				#tween.connect("finished",Callable(self,"_turn_ended"))
				#tween.play()
			entity.position = new_coords
			entity.energy_component.remove_energy(cost)
			
			LogDuck.d(entity.name, offset)
			if entity.energy_component.check_energy_empty():
				#Still have enough energy
				return true
			else:
				#Ran out of energy
				return false
			
			#Ran into an object
			#else: return false
		else:
			LogDuck.e("Entity: ", entity.name, " not enough energy")
			return false
	else:
		LogDuck.e("Entity: ", entity.name, " can't move")
		return false

#func move(direction: Vector2i) -> void:
	#if energy_component.check_energy(self):
		#var coord: Vector2i = Global.get_coord_from_sprite(entity)
		#coord += direction
		#var new_coords: Vector2 = Global.get_position_from_coord(coord)
		#
		#if _check_direction(direction):
			##tween = create_tween()
			##tween.tween_property(self, "position", new_coords, 0.1)
			##tween.connect("finished",Callable(self,"_turn_ended"))
			##tween.play()
			#entity.position = new_coords
			#energy_component.remove_energy(cost)
			##_turn_ended()
		#else: pass
	#else: print("Not enough energy")

func _check_direction(direction: Vector2) -> Object:
	#check if there is an object
	#if no object move there
	#if there is an entity there -> we can attack it
	#If there is a tilemap there we can't move there
	
	
	LogDuck.d(direction)
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
			
			LogDuck.w(entity_collider_parent)
			return entity_collider_parent
			#print(entity_collider_parent)
			#const CustomClass = preload("res://library/entity.gd")
			#if entity.entity_type == Entity.entity_types.ENEMY && entity_collider_parent.entity_type == Entity.entity_types.ENEMY:
				#return false
			#
			#print("Attack")
			#entity_collider_parent._update_health(-entity_attack)
		
		return entity_collider

func return_entity() -> Entity:
	return

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
