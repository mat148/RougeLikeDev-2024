extends Node

var entities_list: Dictionary = {}

var entities_order: Array = []
var entity_order_index: int = 0

func _init() -> void:
	SignalManager.entity_created.connect(add_entity_to_list)
	#SignalManager.turn_ended.connect(next_entity_in_turn_order)

func reset_schedule_manager() -> void:
	entities_list.clear()
	entities_order.clear()
	entity_order_index = 0

func add_entity_to_list(entity: Entity) -> void:
	#if entity.entity_type == Entity.entity_types.PLAYER:
		#current_entity_turn = entity.entity_id
	entities_list[entity.entity_id] = entity

func player_turn_start() -> void:
	Global.player.entity_start_turn()

func next_entity_in_turn_order() -> void:
	if entities_order:
		if entity_order_index >= entities_order.size():
			entity_order_index = 0
			player_turn_start()
			return
		
		var next_entity = entities_order[entity_order_index]
		entity_order_index += 1
		next_entity.entity_start_turn()

#func next_entity_in_turn_order(previous_entity: Entity = null) -> void:
	#print('prev entity: ', previous_entity)
	#var previous_entity_index = -1
	#
	#if previous_entity != null:
		#previous_entity_index = entities_order.find(previous_entity)
	##print(previous_entity_index)
#
		#if previous_entity_index + 1 >= entities_order.size():
			#previous_entity_index = -1
	#
	#var next_entity = entities_order[previous_entity_index + 1]
	#next_entity.turn_started(next_entity)
	##print(next_entity.name)
	##SignalManager.turn_started.emit(next_entity)

func add_entities_to_order(entity: Entity) -> void:
	print('Entity added to order: ', entity.name)
	var search = entities_order.find(entity)
	
	if search == -1:
		entities_order.append(entity)

#func _physics_process(_delta: float) -> void:
	#var action: Action = await Global.player.input_component.get_action(Global.player)
	#print('schedule action: ', action)
	#
	#if action:
		#if action.perform():
			#print('perform')
	#if action:
		#var previous_player_position: Vector2i = player.grid_position
		#if action.perform():
			#_handle_enemy_turns()
			#map.update_fov(player.grid_position)

#func _physics_process(delta: float) -> void:
	#for entity in entities_order:
		#var action: Action = await entity.get_entity_action()
		#
		#if action:
			#print(action)

#func _ready() -> void:
	#start_entity_turn_order()
#
#func add_entity_to_list(entity: Entity) -> void:
	#if entity.entity_type == Entity.entity_types.PLAYER:
		#current_entity_turn = entity.entity_id
	#
	#entities_list[entity.entity_id] = entity
#
#func remove_entity_from_list(entity: Entity) -> void:
	#entities_list.erase(entity.entity_id)
#
#func add_entities_to_order(entity: Entity) -> void:
	#var search = entities_order.find(entity)
	#
	#if search == -1:
		#entities_order.append(entity)
#
#func start_entity_turn_order() -> void:
	##var first_entity_id = entities_list.keys()[0]
	#var first_entity = entities_order[0]
	##print('turn start: ', first_entity.name)
	#SignalManager.turn_started.emit(first_entity)
#
#func next_entity_in_turn_order(previous_entity: Entity) -> void:
	#var previous_entity_index = entities_order.find(previous_entity)
	##print(previous_entity_index)
#
	#if previous_entity_index + 1 >= entities_order.size():
		#previous_entity_index = -1
	#
	#var next_entity = entities_order[previous_entity_index + 1]
	##print(next_entity.name)
	#SignalManager.turn_started.emit(next_entity)
