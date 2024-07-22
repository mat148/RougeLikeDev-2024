extends Node
class_name InputComponent

signal turn_end

@export var move_action: MoveAction
@export var attack_action: AttackAction
@export var energy_component: EnergyComponent

#TODO Refactor
func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("skip_turn"):
			after_input(Vector2.ZERO)
		if Input.is_action_just_pressed("move_left"):
			after_input(Vector2.LEFT)
		if Input.is_action_just_pressed("move_right"):
			after_input(Vector2.RIGHT)
		if Input.is_action_just_pressed("move_up"):
			after_input(Vector2.UP)
		if Input.is_action_just_pressed("move_down"):
			after_input(Vector2.DOWN)

func after_input(direction: Vector2) -> void:
	var new_entity = move_action._check_direction(direction)
	
	if new_entity == null:
		move_action.offset = direction
		var perform = await move_action.perform()
		
		if !perform && !energy_component.check_energy_empty():
			turn_end.emit()
	else:
		#Object in the way
		if new_entity.entity_type == Entity.entity_types.ENEMY:
			attack_action.offset = direction
			attack_action.target = new_entity
			var perform = await attack_action.perform()
			
			if !perform && !energy_component.check_energy_empty():
				turn_end.emit()

#func get_action() -> Action:
	#return Action

#const directions = {
	#"move_up": Vector2i.UP,
	#"move_down": Vector2i.DOWN,
	#"move_left": Vector2i.LEFT,
	#"move_right": Vector2i.RIGHT
#}

#func get_action(player: Entity) -> Action:
	#var action: Action = null
	#
	#for direction in directions:
		#print(direction)
		#if Input.is_action_just_pressed(direction):
			#print('direction: ', direction)
			#var offset: Vector2i = directions[direction]
			#action = MoveAction.new(player, offset.x, offset.y)
			#print('input action: ', action)
	
	#if Input.is_action_just_pressed("wait"):
		#action = WaitAction.new(player)
	#
	#if Input.is_action_just_pressed("view_history"):
		#get_parent().transition_to(InputHandler.InputHandlers.HISTORY_VIEWER)
	#
	#if Input.is_action_just_pressed("quit") or Input.is_action_just_pressed("ui_back"):
		#action = EscapeAction.new(player)
	
	#return action
