extends Node

@export var healthUI: Label

func update_health_UI(health: int) -> void:
	healthUI.text = str(health)
