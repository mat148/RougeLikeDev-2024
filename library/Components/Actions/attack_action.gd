extends Action
class_name AttackAction

var offset: Vector2i
var target: Entity
var tween: Tween

var entity_attack: int = 0

#func _init(new_entity: Entity = null, dx: int = 0, dy: int = 0) -> void:
	#entity = new_entity
	#offset = Vector2i(dx, dy)

func set_base_attack(base_attack: int) -> void:
	entity_attack = base_attack

#TODO figure out why enemies attack when player is moving away.
#Attack of oppourtunity
func perform() -> bool:
	if entity.entity_can_move:
		if entity.energy_component.check_energy_action(self):
			var coord: Vector2i = Global.get_coord_from_sprite(entity)
			coord += offset
			var new_coords: Vector2 = Global.get_position_from_coord(coord)
			
			target.health_component.remove_health(entity.attack_action.entity_attack)
			entity.energy_component.remove_energy(cost)
			
			LogDuck.w(entity.name, target.name)
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
