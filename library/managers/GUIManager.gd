extends Node

@export var devConsoleUI: Control

@export var healthUI: Label

#func _ready() -> void:
	#SignalManager.dev_console.connect(toggle_dev_console)

func update_health_UI(health: int) -> void:
	healthUI.text = str(health)

#func toggle_dev_console() -> void:
	#devConsoleUI.visible = !devConsoleUI.visible
	#get_tree().paused = devConsoleUI.visible
