extends Node
class_name EnemyComponent

signal end_turn

@export var move_action: MoveAction
@export var attack_action: AttackAction
@export var energy_component: EnergyComponent

var parent: Entity = null
var path_to_player_array: Array[Vector2i] = []

func _ready() -> void:
	parent = get_parent()

func ai() -> void:
	#TODO Immplement navigating to player's last location if lost player
	while energy_component.check_energy_empty():
		var LookForPlayerRayCast2D = parent.get_node('LookForPlayerRayCast2D')
	
		LookForPlayerRayCast2D.look_at(Global.player.global_position)
		LookForPlayerRayCast2D.force_raycast_update()
		
		var entity_area = LookForPlayerRayCast2D.get_collider()
		var entity
		
		if entity_area:
			if entity_area.name != 'TileMap' && entity_area.name != 'EntityDetectionArea2D':
				LogDuck.d(entity_area, entity_area.name)
				entity = entity_area.get_parent()
		
		if entity:
			#Found player
			LogDuck.d("player found")
			path_to_player()
			
			var direction = Vector2.ZERO
			direction = path_to_player_array[0] - Global.get_coord_from_sprite(parent)
			
			var new_entity = move_action._check_direction(direction)
			
			if new_entity == null:
				move_action.offset = direction
				var perform = await move_action.perform()
				await Global.wait(0.3)
				if !perform && !energy_component.check_energy_empty():
					end_turn.emit()
				
			else:
				#Attack player
				if new_entity.entity_type == Entity.entity_types.PLAYER:
					attack_action.offset = direction
					attack_action.target = new_entity
					var perform = await attack_action.perform()
					
					if !perform && !energy_component.check_energy_empty():
						end_turn.emit()
		else:
			#No player, move random
			var direction = get_non_diagonal_direction()
			var new_entity = move_action._check_direction(direction)
			LogDuck.d(new_entity)
			
			if new_entity == null:
				move_action.offset = direction
				var perform = await move_action.perform()
				await Global.wait(0.3)
				if !perform && !energy_component.check_energy_empty():
					end_turn.emit()
			
	#if !energy_component.check_energy_empty():
		#end_turn.emit()
	
	#
	#for x in 3:
		#move_action.offset = Vector2.UP
		#var perform = await move_action.perform()
		#await Global.wait(0.3)
		#if !perform && !energy_component.check_energy_empty():
			#end_turn.emit()
			#break

func get_non_diagonal_direction() -> Vector2:
	var horizontal = randi() % 2 == 0  # Randomly choose between horizontal or vertical
	var direction = Vector2()

	if horizontal:
		direction.x = randi_range(-1, 1)
		direction.y = 0
	else:
		direction.x = 0
		direction.y = randi_range(-1, 1)

	return direction

func path_to_player() -> void:
	var game_manager = Global.game_manager
	var path: Array[Vector2i] = game_manager.find_path(
		Global.get_coord_from_sprite(parent),
		#last_known_player_position
		Global.get_coord_from_sprite(Global.player)
	)
	
	#print('Entity position: ', Global.get_coord_from_sprite(self))
	#print('path to player: ', path)
	#print('Player pos: ', Global.get_coord_from_sprite(Global.player))
	
	path.pop_front()
	path_to_player_array = path
	
	for tile in path_to_player_array:
		game_manager.tile_map.set_cell(0, tile, 0, Vector2(4,1), 0)
