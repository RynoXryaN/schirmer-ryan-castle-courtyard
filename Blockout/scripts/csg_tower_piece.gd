@tool
class_name CSGTowerPiece
extends CSGPieceBase


enum SideFeature { NONE, WINDOW, DOOR }


#region /// Exported Variables: Tower

@export_category("Tower")

@export var tower_width_units: int = 2:
	set(value):
		tower_width_units = safe_int(value)
		if auto_update:
			update_piece()

@export var tower_depth_units: int = 2:
	set(value):
		tower_depth_units = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_count: int = 2:
	set(value):
		floor_count = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_height_units: int = 1:
	set(value):
		floor_height_units = safe_int(value)
		if auto_update:
			update_piece()

@export var wall_thickness_units: float = 0.25:
	set(value):
		wall_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Roof

@export_category("Roof")

@export var roof_enabled: bool = true:
	set(value):
		roof_enabled = value
		if auto_update:
			update_piece()

@export var roof_thickness_units: float = 0.1:
	set(value):
		roof_thickness_units = safe_float(value, 0.025)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Openings Floor 01

@export_category("Openings: Floor 01")

@export var floor_01_north: SideFeature = SideFeature.DOOR:
	set(value):
		floor_01_north = value
		if auto_update:
			update_piece()

@export var floor_01_east: SideFeature = SideFeature.NONE:
	set(value):
		floor_01_east = value
		if auto_update:
			update_piece()

@export var floor_01_south: SideFeature = SideFeature.NONE:
	set(value):
		floor_01_south = value
		if auto_update:
			update_piece()

@export var floor_01_west: SideFeature = SideFeature.NONE:
	set(value):
		floor_01_west = value
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Openings Floor 02

@export_category("Openings: Floor 02")

@export var floor_02_north: SideFeature = SideFeature.WINDOW:
	set(value):
		floor_02_north = value
		if auto_update:
			update_piece()

@export var floor_02_east: SideFeature = SideFeature.WINDOW:
	set(value):
		floor_02_east = value
		if auto_update:
			update_piece()

@export var floor_02_south: SideFeature = SideFeature.WINDOW:
	set(value):
		floor_02_south = value
		if auto_update:
			update_piece()

@export var floor_02_west: SideFeature = SideFeature.WINDOW:
	set(value):
		floor_02_west = value
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Opening Shape

@export_category("Opening Shape")

@export var opening_depth_units: float = 0.35:
	set(value):
		opening_depth_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var window_width_units: float = 0.4:
	set(value):
		window_width_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var window_height_units: float = 0.55:
	set(value):
		window_height_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var door_width_units: float = 0.55:
	set(value):
		door_width_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var door_height_units: float = 0.9:
	set(value):
		door_height_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var arch_sides: int = 12:
	set(value):
		arch_sides = max(value, 4)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Parapet

@export_category("Parapet")

@export var parapet_height_units: float = 0.25:
	set(value):
		parapet_height_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var parapet_thickness_units: float = 0.25:
	set(value):
		parapet_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Merlons

@export_category("Merlons")

@export var merlon_count_per_side: int = 3:
	set(value):
		merlon_count_per_side = max(value, 0)
		if auto_update:
			update_piece()

@export var merlon_width_units: float = 0.3:
	set(value):
		merlon_width_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var merlon_height_units: float = 0.35:
	set(value):
		merlon_height_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var merlon_thickness_units: float = 0.25:
	set(value):
		merlon_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	_update_walls()
	_update_roof()
	_update_openings()
	_update_parapet()
	_update_merlons()
	pass


func _update_walls() -> void:
	var walls := get_node_or_null("Walls") as Node3D
	if walls == null:
		return

	var north_wall := walls.get_node_or_null("NorthWall") as CSGBox3D
	var south_wall := walls.get_node_or_null("SouthWall") as CSGBox3D
	var east_wall := walls.get_node_or_null("EastWall") as CSGBox3D
	var west_wall := walls.get_node_or_null("WestWall") as CSGBox3D

	if north_wall == null or south_wall == null or east_wall == null or west_wall == null:
		return

	var tower_width := unit(tower_width_units)
	var tower_depth := unit(tower_depth_units)
	var tower_height := unit(floor_count * floor_height_units)
	var wall_thickness := unit(wall_thickness_units)

	north_wall.size = Vector3(tower_width, tower_height, wall_thickness)
	north_wall.position = Vector3(0.0, tower_height / 2.0, -tower_depth / 2.0 + wall_thickness / 2.0)

	south_wall.size = Vector3(tower_width, tower_height, wall_thickness)
	south_wall.position = Vector3(0.0, tower_height / 2.0, tower_depth / 2.0 - wall_thickness / 2.0)

	east_wall.size = Vector3(wall_thickness, tower_height, tower_depth)
	east_wall.position = Vector3(tower_width / 2.0 - wall_thickness / 2.0, tower_height / 2.0, 0.0)

	west_wall.size = Vector3(wall_thickness, tower_height, tower_depth)
	west_wall.position = Vector3(-tower_width / 2.0 + wall_thickness / 2.0, tower_height / 2.0, 0.0)
	pass


func _update_roof() -> void:
	var roof := get_node_or_null("Roof") as CSGBox3D
	if roof == null:
		return

	roof.visible = roof_enabled
	roof.use_collision = roof_enabled

	if not roof_enabled:
		return

	var tower_width := unit(tower_width_units)
	var tower_depth := unit(tower_depth_units)
	var tower_height := unit(floor_count * floor_height_units)
	var wall_thickness := unit(wall_thickness_units)
	var roof_thickness := unit(roof_thickness_units)

	var interior_width := tower_width - wall_thickness * 2.0
	var interior_depth := tower_depth - wall_thickness * 2.0

	roof.size = Vector3(interior_width, roof_thickness, interior_depth)
	roof.position = Vector3(0.0, tower_height, 0.0)
	pass


func _update_openings() -> void:
	var walls := get_node_or_null("Walls") as Node3D
	if walls == null:
		return

	for wall in walls.get_children():
		for child in wall.get_children():
			child.queue_free()

	_add_floor_openings(1, floor_01_north, floor_01_east, floor_01_south, floor_01_west)
	_add_floor_openings(2, floor_02_north, floor_02_east, floor_02_south, floor_02_west)
	pass


func _add_floor_openings(floor_number: int, north: SideFeature, east: SideFeature, south: SideFeature, west: SideFeature) -> void:
	if floor_number > floor_count:
		return

	var floor_height := unit(floor_height_units)
	var y := unit((floor_number - 1) * floor_height_units) + floor_height / 2.0

	_add_opening("North", north, y)
	_add_opening("East", east, y)
	_add_opening("South", south, y)
	_add_opening("West", west, y)
	pass


func _add_opening(side_name: String, feature: SideFeature, y: float) -> void:
	if feature == SideFeature.NONE:
		return

	var walls := get_node_or_null("Walls") as Node3D
	if walls == null:
		return

	var target_wall: CSGBox3D = null

	match side_name:
		"North":
			target_wall = walls.get_node_or_null("NorthWall") as CSGBox3D
		"South":
			target_wall = walls.get_node_or_null("SouthWall") as CSGBox3D
		"East":
			target_wall = walls.get_node_or_null("EastWall") as CSGBox3D
		"West":
			target_wall = walls.get_node_or_null("WestWall") as CSGBox3D

	if target_wall == null:
		return

	var tower_height := unit(floor_count * floor_height_units)

	var opening_width := unit(window_width_units)
	var opening_height := unit(window_height_units)
	var opening_depth := unit(opening_depth_units)

	if feature == SideFeature.DOOR:
		opening_width = unit(door_width_units)
		opening_height = unit(door_height_units)

	var cutout := CSGPolygon3D.new()
	cutout.name = "%s_%s_Cutout" % [side_name, SideFeature.keys()[feature]]
	cutout.operation = CSGShape3D.OPERATION_SUBTRACTION
	cutout.depth = opening_depth
	cutout.polygon = _make_arch_polygon(opening_width, opening_height)

	var local_y := y - tower_height / 2.0

	match side_name:
		"North":
			cutout.position = Vector3(0.0, local_y, opening_depth / 2.0)

		"South":
			cutout.position = Vector3(0.0, local_y, opening_depth / 2.0)

		"East":
			cutout.position = Vector3(opening_depth / 2.0, local_y, 0.0)
			cutout.rotation_degrees.y = 90.0

		"West":
			cutout.position = Vector3(opening_depth / 2.0, local_y, 0.0)
			cutout.rotation_degrees.y = 90.0

	target_wall.add_child(cutout)
	cutout.owner = get_tree().edited_scene_root
	pass


func _make_arch_polygon(opening_width: float, opening_height: float) -> PackedVector2Array:
	var half_width := opening_width / 2.0
	var arch_radius := half_width
	var rect_height: float = maxf(opening_height - arch_radius, unit(0.1))

	var bottom_y := -opening_height / 2.0
	var shoulder_y := bottom_y + rect_height

	var points := PackedVector2Array()

	points.append(Vector2(-half_width, bottom_y))
	points.append(Vector2(half_width, bottom_y))
	points.append(Vector2(half_width, shoulder_y))

	for i in range(arch_sides + 1):
		var t := PI * float(i) / float(arch_sides)
		var x := cos(t) * arch_radius
		var y := shoulder_y + sin(t) * arch_radius
		points.append(Vector2(x, y))

	points.append(Vector2(-half_width, shoulder_y))

	return points


func _update_parapet() -> void:
	var parapet := get_node_or_null("Parapet") as Node3D
	if parapet == null:
		return

	for child in parapet.get_children():
		child.queue_free()

	var tower_width := unit(tower_width_units)
	var tower_depth := unit(tower_depth_units)
	var tower_height := unit(floor_count * floor_height_units)
	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)

	_add_parapet_wall(parapet, "NorthParapet", Vector3(tower_width, parapet_height, parapet_thickness), Vector3(0.0, tower_height + parapet_height / 2.0, -tower_depth / 2.0 + parapet_thickness / 2.0))
	_add_parapet_wall(parapet, "SouthParapet", Vector3(tower_width, parapet_height, parapet_thickness), Vector3(0.0, tower_height + parapet_height / 2.0, tower_depth / 2.0 - parapet_thickness / 2.0))
	_add_parapet_wall(parapet, "EastParapet", Vector3(parapet_thickness, parapet_height, tower_depth), Vector3(tower_width / 2.0 - parapet_thickness / 2.0, tower_height + parapet_height / 2.0, 0.0))
	_add_parapet_wall(parapet, "WestParapet", Vector3(parapet_thickness, parapet_height, tower_depth), Vector3(-tower_width / 2.0 + parapet_thickness / 2.0, tower_height + parapet_height / 2.0, 0.0))
	pass


func _add_parapet_wall(parent: Node3D, wall_name: String, wall_size: Vector3, wall_position: Vector3) -> void:
	var wall := CSGBox3D.new()
	wall.name = wall_name
	wall.size = wall_size
	wall.position = wall_position
	parent.add_child(wall)
	wall.owner = get_tree().edited_scene_root
	pass


func _update_merlons() -> void:
	var merlons := get_node_or_null("Merlons") as Node3D
	if merlons == null:
		return

	for child in merlons.get_children():
		child.queue_free()

	if merlon_count_per_side <= 0:
		return

	var tower_width := unit(tower_width_units)
	var tower_depth := unit(tower_depth_units)
	var tower_height := unit(floor_count * floor_height_units)
	var parapet_height := unit(parapet_height_units)

	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_thickness := unit(merlon_thickness_units)

	var y := tower_height + parapet_height + merlon_height / 2.0

	_add_merlon_row(merlons, "North", tower_width, tower_depth, y, merlon_width, merlon_height, merlon_thickness)
	_add_merlon_row(merlons, "South", tower_width, tower_depth, y, merlon_width, merlon_height, merlon_thickness)
	_add_merlon_row(merlons, "East", tower_width, tower_depth, y, merlon_width, merlon_height, merlon_thickness)
	_add_merlon_row(merlons, "West", tower_width, tower_depth, y, merlon_width, merlon_height, merlon_thickness)
	pass


func _add_merlon_row(merlons: Node3D, side_name: String, tower_width: float, tower_depth: float, y: float, merlon_width: float, merlon_height: float, merlon_thickness: float) -> void:
	var count := merlon_count_per_side
	var span := tower_width

	if side_name == "East" or side_name == "West":
		span = tower_depth

	var spacing := span / float(count)
	var start := -span / 2.0 + spacing / 2.0

	for i in count:
		var merlon := CSGBox3D.new()
		merlon.name = "%s_Merlon_%02d" % [side_name, i]

		match side_name:
			"North":
				merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
				merlon.position = Vector3(start + spacing * i, y, -tower_depth / 2.0 + merlon_thickness / 2.0)
			"South":
				merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
				merlon.position = Vector3(start + spacing * i, y, tower_depth / 2.0 - merlon_thickness / 2.0)
			"East":
				merlon.size = Vector3(merlon_thickness, merlon_height, merlon_width)
				merlon.position = Vector3(tower_width / 2.0 - merlon_thickness / 2.0, y, start + spacing * i)
			"West":
				merlon.size = Vector3(merlon_thickness, merlon_height, merlon_width)
				merlon.position = Vector3(-tower_width / 2.0 + merlon_thickness / 2.0, y, start + spacing * i)

		merlons.add_child(merlon)
		merlon.owner = get_tree().edited_scene_root

	pass

#endregion
