extends Node

@export var tiles: Dictionary = {}

@export var pc_scene: PackedScene
@export var goblin_scene: PackedScene
@export var game_container: Node2D
@export var tile_map: TileMap

var astar_grid
@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

@export_category("Rooms RNG")
@export var max_rooms: int = 20
@export var room_max_size: int = 10
@export var room_min_size: int = 6

@export_category("Monsters RNG")
@export var max_monsters_per_room = 2

var _rng := RandomNumberGenerator.new()

var rooms: Array[Rect2i] = []
#var entities: Array = []

func _ready() -> void:
	_rng.randomize()
	_setup_astar()
	_create_pc()
	_setup_tiles()

func _setup_astar() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.set_diagonal_mode(true)
	astar_grid.region = Rect2i(0, 0, map_width, map_height)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()

func _setup_tiles() -> void:
	for y in map_height:
		for x in map_width:
			_carve_tile(tiles.block, x, y)
	
	_create_world()

func _create_world() -> void:
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, map_width - room_width - 1)
		var y: int = _rng.randi_range(0, map_height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		_carve_room(new_room)
		
		if rooms.is_empty():
			Global.player.position = Global.get_position_from_coord(new_room.get_center())
		else:
			_tunnel_between(rooms.back().get_center(), new_room.get_center())
		
		_place_entities(new_room)
		
		rooms.append(new_room)
	
	#_place_entities(rooms[0])
	#print(Global.get_coord_from_sprite(Global.player))
	#var enemy = Global.schedule_manager.entities_list[Global.schedule_manager.entities_list.keys()[1]]
	##print(Global.get_coord_from_sprite(enemy))
	#print(astar_grid.get_id_path(Global.get_coord_from_sprite(Global.player), Global.get_coord_from_sprite(enemy)))

func _carve_room(room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_carve_tile(tiles.grass_1, x, y)

func _carve_tile(tile: Tile, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	tile_map.set_cell(0, tile_position, 0, tile.tile_cordinates, 0)
	astar_grid.set_point_solid(tile_position, tile.tile_blocking)

func _tunnel_horizontal(y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		_carve_tile(tiles.grass_1, x, y)

func _tunnel_vertical(x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_carve_tile(tiles.grass_1, x, y)

func _tunnel_between(start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(start.y, start.x, end.x)
		_tunnel_vertical(end.x, start.y, end.y)
	else:
		_tunnel_vertical(start.x, start.y, end.y)
		_tunnel_horizontal(end.y, start.x, end.x)

func _create_pc() -> void:
	#var pc = Entity.new(Global.get_position_from_coord(Vector2i(3, 1)), Entity.entity_types.PLAYER, load('Resources/Brawler.tres'))
	var pc = pc_scene.instantiate()
	pc.name = 'Player'
	pc.entity_type = Entity.entity_types.PLAYER
	#pc.position = Global.get_position_from_coord(Vector2i(3, 1))
	pc.set_entity_class(load('Resources/Warrior.tres'))
	game_container.add_child(pc)
	Global.player = pc
	SignalManager.entity_created.emit(pc)
	Global.schedule_manager.entities_order.append(pc)
	
	#for x in 20:
		#var entity: Entity = goblin_scene.instantiate()
		#entity.name = 'Enemy'
		#entity.entity_type = Entity.entity_types.ENEMY
		#entity.entity_class = load('Resources/Brawler.tres')
		##entity.modulate = Color.RED
		#entity.position = Global.get_position_from_coord(Vector2(x,x))
		#game_container.add_child(entity)
		#SignalManager.entity_created.emit(entity)

func _place_entities(room: Rect2i) -> void:
	#var number_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	var number_of_monsters: int = 3
	
	for _i in number_of_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2(x, y)
		
		var can_place = true
		for entity in Global.schedule_manager.entities_list.values():
			if entity.position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity = goblin_scene.instantiate()
			##if _rng.randf() < 0.8:
				###new_entity = Entity.new(new_entity_position, Entity.entity_types.ENEMY, load('Resources/Brawler.tres'))
				##new_entity.name = 'Enemy'
				##new_entity.entity_type = Entity.entity_types.ENEMY
				##new_entity.position = Global.get_position_from_coord(new_entity_position)
				##
				##game_container.add_child(new_entity)
				##SignalManager.entity_created.emit(new_entity)
				##
			##else:
				##new_entity = Entity.new(new_entity_position, Entity.entity_types.ENEMY, load('Resources/Brawler.tres'))
			#
			new_entity.set_entity_class(load('Resources/Warrior.tres'))
			new_entity.name = 'Enemy'
			new_entity.entity_type = Entity.entity_types.ENEMY
			new_entity.position = Global.get_position_from_coord(new_entity_position)
			
			game_container.add_child(new_entity)
			SignalManager.entity_created.emit(new_entity)

func find_path(position_a: Vector2, position_b: Vector2) -> Array[Vector2i]:
	var path = astar_grid.get_id_path(position_a, position_b)
	
	return path


#print(Global.get_coord_from_sprite(Global.player))
#var enemy = Global.schedule_manager.entities_list[Global.schedule_manager.entities_list.keys()[1]]
##print(Global.get_coord_from_sprite(enemy))
#print(astar_grid.get_id_path(Global.get_coord_from_sprite(Global.player), Global.get_coord_from_sprite(enemy)))
