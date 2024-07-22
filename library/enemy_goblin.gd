extends Entity
class_name EnemyGoblin

var last_known_player_position

@export var enemy_component: EnemyComponent
@export var attack_action: AttackAction

func _ready() -> void:
	enemy_component.end_turn.connect(entity_end_turn)

func entity_start_turn() -> void:
	LogDuck.d('Start turn: ', name)
	energy_component.start_turn()
	entity_can_move = true
	
	enemy_component.ai()

func update_entity_ray_collision_exception() -> void:
	for entity: Entity in Global.schedule_manager.entities_list.values():
		if entity != self && entity.entity_type != Entity.entity_types.PLAYER:
			%LookForPlayerRayCast2D.add_exception(entity.get_node('CollisionDetection'))
