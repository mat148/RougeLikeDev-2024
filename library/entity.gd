extends Node2D
class_name Entity

var tween: Tween

var entity_id: int
var entity_health: int
var entity_attack: int

enum entity_types {PLAYER, ENEMY}
@export var entity_type: entity_types

@export var entity_class: Class

var entity_can_move: bool = false

var last_known_player_position

func _init() -> void:
	SignalManager.turn_started.connect(turn_started)
	entity_id = Global.get_new_entity_id()

func set_entity_class(new_entity_class: Class) -> void:
	entity_class = new_entity_class
	entity_health = entity_class.entity_class_base_health
	%HealthBar.max_value = entity_health
	%HealthBar.value = entity_health
	entity_attack = entity_class.entity_class_base_attack

#TODO figure out why enemies are taking two turns
func turn_started(entity: Entity) -> void:
	if self == entity:
		#print('turn started: ', entity.name)
		entity_can_move = true
		if entity.entity_type != Entity.entity_types.PLAYER:
			enemy_ai()

func enemy_ai() -> void:
	%LookForPlayerRayCast2D.look_at(Global.player.global_position)
	%LookForPlayerRayCast2D.force_raycast_update()
	
	var entity_area = %LookForPlayerRayCast2D.get_collider()
	var entity
	
	if entity_area:
		if entity_area.name != 'TileMap' && entity_area.name != 'entity_detection_area2D':
			entity = entity_area.get_parent()
	
	#TODO last known player position isn't functioning as expected
	#var vector2i = Vector2i(myvector2) / 32
	#if last_known_player_position == Vector2i(position):
		#last_known_player_position = null
	#
	#if last_known_player_position:
		#path_to_player()
	
	if entity && entity.entity_type == Entity.entity_types.PLAYER:
		#last_known_player_position = Global.get_coord_from_sprite(Global.player)
		path_to_player()
	else:
		_move(get_non_diagonal_direction())

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
	var path = game_manager.find_path(
		Global.get_coord_from_sprite(self),
		#last_known_player_position
		Global.get_coord_from_sprite(Global.player)
	)
	
	#print('Entity position: ', Global.get_coord_from_sprite(self))
	#print('path to player: ', path)
	#print('Player pos: ', Global.get_coord_from_sprite(Global.player))
	
	for tile in path:
		game_manager.tile_map.set_cell(0, tile, 0, Vector2(4,1), 0)
	
	var direction = Vector2.ZERO
	if path.size() > 1:
		direction = path[1] - Global.get_coord_from_sprite(self)
	
	_move(direction)

#on turn - enemy
#if haven't spotted pc
	#wander
#spotted pc
	#get within range
		#brawler - close
		#ranger - far
	#attack

func _move(direction: Vector2i) -> void:
	entity_can_move = false
	#print('moving: ', self.name)
	var coord: Vector2i = Global.get_coord_from_sprite(self)
	coord += direction

	var new_coords: Vector2 = Global.get_position_from_coord(coord)
	if _check_direction(direction):
		tween = create_tween()
		tween.tween_property(self, "position", new_coords, 0.1)
		tween.connect("finished",Callable(self,"_turn_ended"))
		tween.play()
	else: _turn_ended()

func _check_direction(direction: Vector2) -> bool:
	var raycast_target_position = direction * Global.STEP_X
	%MoveCheckRayCast2D.target_position = raycast_target_position
	%MoveCheckRayCast2D.force_raycast_update()
	var entity_collider = %MoveCheckRayCast2D.get_collider()
	if entity_collider == null:
		return true
	else:
		if entity_collider.name != 'TileMap':
			var entity_collider_parent = entity_collider.get_parent()
			#print(entity_collider_parent)
			const CustomClass = preload("res://library/entity.gd")
			if entity_collider_parent is CustomClass:
				entity_collider_parent._update_health(-entity_attack)
		
		return false

func _turn_ended() -> void:
	if tween:
		tween.kill()
	#print('turn end: ', self.name)
	SignalManager.turn_ended.emit(self)
	
	if self.name != 'Player' && entity_health <= 0:
		#Global.schedule_manager.remove_entity_from_list(self)
		queue_free()

func _update_health(health_amount: int) -> void:
	entity_health += health_amount
	
	if self.name == 'Player':
		Global.gui_manager.update_health_UI(entity_health)
	else:
		%HealthBar.value = entity_health
