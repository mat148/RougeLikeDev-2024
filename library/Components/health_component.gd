extends Node
class_name HealthComponent

@export var health_bar: ProgressBar = null

var entity_heath: int

func set_health(health: int) -> void:
	entity_heath = health
	
	if health_bar:
		health_bar.max_value = entity_heath
		health_bar.value = entity_heath

func add_health(health: int) -> void:
	entity_heath += health
	
	if health_bar:
		health_bar.value = entity_heath

func remove_health(health: int) -> void:
	entity_heath -= health
	
	if health_bar:
		health_bar.value = entity_heath
