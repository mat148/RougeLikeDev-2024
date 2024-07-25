extends Node

const STEP_X: int = 16
const STEP_Y: int = 16

var entity_id: int = 0

var game_manager: Node = null
var input_manager: Node = null
var schedule_manager: Node = null
var gui_manager: Node = null
var player = null

func _ready():
	game_manager = get_tree().root.get_node('MainScreen/Managers/GameManager')
	input_manager = get_tree().root.get_node('MainScreen/Managers/InputManager')
	schedule_manager = get_tree().root.get_node('MainScreen/Managers/ScheduleManager')
	gui_manager = get_tree().root.get_node('MainScreen/Managers/GUIManager')

func get_new_entity_id() -> int:
	var current_id = entity_id
	entity_id += 1

	return current_id

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func get_position_from_coord(coord: Vector2i, offset: Vector2i = Vector2i(STEP_X/2, STEP_Y/2)) -> Vector2:
	var new_x: int = STEP_X * coord.x + offset.x
	var new_y: int = STEP_Y * coord.y + offset.y
	return Vector2(new_x, new_y)

func get_coord_from_sprite(entity_ref: Entity) -> Vector2i:
	var new_x: int = floor((entity_ref.position.x) / STEP_X)
	var new_y: int = floor((entity_ref.position.y) / STEP_Y)
	return Vector2(new_x, new_y)

func get_coord_from_coord(coord: Vector2i) -> Vector2:
	var new_x: int = floor((coord.x) / STEP_X)
	var new_y: int = floor((coord.y) / STEP_Y)
	return Vector2(new_x, new_y)

func vector2_to_vector2i(vector: Vector2) -> Vector2i:
	return Vector2i(vector) / 32
