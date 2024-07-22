extends Node
class_name EnergyComponent

var max_energy: int = 0
var energy: int = 0

func set_max_energy(max_energy_set: int) -> void:
	max_energy = max_energy_set

func set_energy(energy_adjustment: int) -> void:
	energy = energy_adjustment

func add_energy(energy_adjustment: int) -> void:
	energy += energy_adjustment

func remove_energy(energy_adjustment: int) -> void:
	energy -= energy_adjustment

func check_energy_action(action: Action) -> bool:
	if energy >= action.cost:
		return true
	else:
		return false

func check_energy_empty() -> bool:
	if energy: return true
	else: return false

func start_turn() -> void:
	LogDuck.d('Energy start')
	energy = max_energy

func end_turn() -> void:
	energy = 0
