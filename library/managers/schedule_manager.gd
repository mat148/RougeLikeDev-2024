extends Node

var entities_list: Dictionary = {}
#var current_entity_turn: int

var entities_order: Array = []

func _init() -> void:
	SignalManager.entity_created.connect(add_entity_to_list)
	SignalManager.turn_ended.connect(next_entity_in_turn_order)

func add_entity_to_list(entity: Entity) -> void:
	#if entity.entity_type == Entity.entity_types.PLAYER:
		#current_entity_turn = entity.entity_id
	entities_list[entity.entity_id] = entity

func next_entity_in_turn_order(previous_entity: Entity = null) -> void:
	var previous_entity_index = -1
	
	if previous_entity != null:
		previous_entity_index = entities_order.find(previous_entity)
	#print(previous_entity_index)

		if previous_entity_index + 1 >= entities_order.size():
			previous_entity_index = -1
	
	var next_entity = entities_order[previous_entity_index + 1]
	#print(next_entity.name)
	SignalManager.turn_started.emit(next_entity)

func add_entities_to_order(entity: Entity) -> void:
	var search = entities_order.find(entity)
	
	if search == -1:
		entities_order.append(entity)

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
