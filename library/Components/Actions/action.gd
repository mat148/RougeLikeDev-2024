extends Node
class_name Action

signal turn_end

@export var entity: Entity
@export var cost : int

#func _init(new_entity: Entity, new_cost: int) -> void:
	#entity = new_entity
	#cost = new_cost

func perform() -> bool:
	return false
