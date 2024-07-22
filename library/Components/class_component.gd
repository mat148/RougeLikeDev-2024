extends Node
class_name ClassComponent

@export var entity_class: Class
@export var energy_component: EnergyComponent
@export var health_component: HealthComponent
@export var attack_action: AttackAction

func _ready() -> void:
	var speed_multiplier: int = 100
	health_component.set_health(entity_class.entity_class_base_health)
	energy_component.set_max_energy(entity_class.entity_class_base_speed * speed_multiplier)
	attack_action.set_base_attack(entity_class.entity_class_base_attack)

#func set_entity_class(new_entity_class: Class) -> void:
	#var speed_multiplier: int = 100
	##entity_class = new_entity_class
	#health_component.set_health(entity_class.entity_class_base_health)
	#energy_component.set_energy(entity_class.entity_class_base_speed * speed_multiplier)
	##%HealthBar.max_value = entity_health
	##%HealthBar.value = entity_health
	##entity_attack = entity_class.entity_class_base_attack
