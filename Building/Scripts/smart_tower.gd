@tool
extends SmartBuildPiece
class_name SmartTower


# ------------------------------------------------------------
# Tower Asset Scenes
# ------------------------------------------------------------

@export_group("Tower Asset Scenes")
@export var wall_scene: PackedScene
@export var wall_door_scene: PackedScene
@export var wall_window_scene: PackedScene
@export var corner_scene: PackedScene
@export var roof_scene: PackedScene
@export var ceiling_scene: PackedScene
@export var floor_scene: PackedScene


# ------------------------------------------------------------
# Tower Size
# ------------------------------------------------------------

@export_group("Tower Size")
@export var tower_width_units: float = 3.0:
	set(value):
		tower_width_units = value
		if Engine.is_editor_hint():
			rebuild()

@export var tower_depth_units: float = 3.0:
	set(value):
		tower_depth_units = value
		if Engine.is_editor_hint():
			rebuild()

@export var floors_count: int = 2:
	set(value):
		floors_count = max(1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var floor_height_units: float = 2.0:
	set(value):
		floor_height_units = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Wall Piece Settings
# ------------------------------------------------------------

@export_group("Wall Piece Settings")
@export var wall_piece_width_units: float = 1.0:
	set(value):
		wall_piece_width_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var wall_thickness_units: float = 0.25:
	set(value):
		wall_thickness_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()


@export_group("Floor Openings")
@export var floor_openings: Array[TowerFloorOpenings] = []:
	set(value):
		floor_openings = value
		if Engine.is_editor_hint():
			rebuild()

# ------------------------------------------------------------
# Door Options
# ------------------------------------------------------------

#@export_group("Door Options")
#@export var show_north_door: bool = false:
	#set(value):
		#show_north_door = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#@export var show_south_door: bool = true:
	#set(value):
		#show_south_door = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#@export var show_east_door: bool = false:
	#set(value):
		#show_east_door = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#@export var show_west_door: bool = false:
	#set(value):
		#show_west_door = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#
## ------------------------------------------------------------
## Window Options
## ------------------------------------------------------------
#
#@export_group("Window Options")
#@export var show_north_windows: bool = true:
	#set(value):
		#show_north_windows = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#@export var show_south_windows: bool = true:
	#set(value):
		#show_south_windows = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#@export var show_east_windows: bool = true:
	#set(value):
		#show_east_windows = value
		#if Engine.is_editor_hint():
			#rebuild()
#
#@export var show_west_windows: bool = true:
	#set(value):
		#show_west_windows = value
		#if Engine.is_editor_hint():
			#rebuild()


# ------------------------------------------------------------
# Roof
# ------------------------------------------------------------

@export_group("Roof / Floor / Ceiling Options")
@export var show_roof: bool = true:
	set(value):
		show_roof = value
		if Engine.is_editor_hint():
			rebuild()

#@export var show_ceilings: bool = true:
	#set(value):
		#show_ceilings = value
		#if Engine.is_editor_hint():
			#rebuild()

#@export var show_floors: bool = true:
	#set(value):
		#show_floors = value
		#if Engine.is_editor_hint():
			#rebuild()


# ------------------------------------------------------------
# Stair Options
# ------------------------------------------------------------

@export_group("Auto Stairs")
@export var generate_stairs: bool = true:
	set(value):
		generate_stairs = value
		if Engine.is_editor_hint():
			rebuild()

@export var stair_width_units: float = 0.75:
	set(value):
		stair_width_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var stair_step_height_units: float = 0.2:
	set(value):
		stair_step_height_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var stair_step_depth_units: float = 0.35:
	set(value):
		stair_step_depth_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var stair_offset_x_units: float = -0.75:
	set(value):
		stair_offset_x_units = value
		if Engine.is_editor_hint():
			rebuild()

@export var stair_offset_z_units: float = 0.75:
	set(value):
		stair_offset_z_units = value
		if Engine.is_editor_hint():
			rebuild()

var _connected_opening_resources: Array[TowerFloorOpenings] = []

@export_group("Parapet")
@export var generate_parapet: bool = true:
	set(value):
		generate_parapet = value
		if Engine.is_editor_hint():
			rebuild()

@export var parapet_height_units: float = 0.35:
	set(value):
		parapet_height_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var parapet_thickness_units: float = 0.18:
	set(value):
		parapet_thickness_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()
			
@export var parapet_overhang_units: float = 0.15:
	set(value):
		parapet_overhang_units = max(0.0, value)
		if Engine.is_editor_hint():
			rebuild()
			
@export_group("Merlons")
@export var generate_merlons: bool = true:
	set(value):
		generate_merlons = value
		if Engine.is_editor_hint():
			rebuild()

@export var merlon_width_units: float = 0.35:
	set(value):
		merlon_width_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var merlon_height_units: float = 0.35:
	set(value):
		merlon_height_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var merlon_depth_units: float = 0.18:
	set(value):
		merlon_depth_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var merlons_per_side: int = 3:
	set(value):
		merlons_per_side = max(1, value)
		if Engine.is_editor_hint():
			rebuild()

# ------------------------------------------------------------
# Runtime
# ------------------------------------------------------------

func _ready() -> void:
	ensure_generated_root()

	if not Engine.is_editor_hint():
		rebuild()


func rebuild() -> void:
	_sync_floor_openings()
	clear_generated()

	_build_walls()
	_build_corners()
	_build_roof()
	_build_parapet()
	_build_merlons()
	#_build_interior()

	#if generate_stairs:
		#build_stairs()
		
		
func _build_walls() -> void:
	var width := unit(tower_width_units)
	var depth := unit(tower_depth_units)
	var floor_height := unit(floor_height_units)

	var half_width := width / 2.0
	var half_depth := depth / 2.0

	var pieces_x: int = max(3, int(round(tower_width_units / wall_piece_width_units)))
	var pieces_z: int = max(3, int(round(tower_depth_units / wall_piece_width_units)))

	for floor_index in range(floors_count):
		var y := floor_height * floor_index
		var openings := _get_floor_openings(floor_index)

		_build_wall_side(
			"North",
			pieces_x,
			Vector3(0.0, y, -half_depth),
			0.0,
			openings.north
		)

		_build_wall_side(
			"South",
			pieces_x,
			Vector3(0.0, y, half_depth),
			180.0,
			openings.south
		)

		_build_wall_side(
			"East",
			pieces_z,
			Vector3(half_width, y, 0.0),
			90.0,
			openings.east
		)

		_build_wall_side(
			"West",
			pieces_z,
			Vector3(-half_width, y, 0.0),
			-90.0,
			openings.west
		)
	pass

func _build_corners() -> void:
	var width := unit(tower_width_units)
	var depth := unit(tower_depth_units)
	var floor_height := unit(floor_height_units)

	var half_width := width / 2.0
	var half_depth := depth / 2.0

	for floor_index in range(floors_count):
		var y := floor_height * floor_index

		spawn_scene(
			corner_scene,
			"Corner_NW_Floor_%d" % floor_index,
			Vector3(-half_width, y, -half_depth),
			90.0
		)

		spawn_scene(
			corner_scene,
			"Corner_NE_Floor_%d" % floor_index,
			Vector3(half_width, y, -half_depth),
			0.0
		)

		spawn_scene(
			corner_scene,
			"Corner_SE_Floor_%d" % floor_index,
			Vector3(half_width, y, half_depth),
			270.0
		)

		spawn_scene(
			corner_scene,
			"Corner_SW_Floor_%d" % floor_index,
			Vector3(-half_width, y, half_depth),
			180.0
		)
	pass

#func _build_floors_and_ceilings() -> void:
	#var floor_height := unit(floor_height_units)
#
	#for floor_index in range(floors_count):
		#var y := floor_height * floor_index
#
		#if show_floors:
			#spawn_scene(
				#floor_scene,
				#"Floor_%d" % floor_index,
				#Vector3.ZERO + Vector3(0.0, y, 0.0),
				#0.0
			#)
#
		#if show_ceilings and floor_index < floors_count - 1:
			#spawn_scene(
				#ceiling_scene,
				#"Ceiling_%d" % floor_index,
				#Vector3(0.0, y + floor_height, 0.0),
				#0.0
			#)
	#pass

func _build_roof() -> void:
	if not show_roof:
		return

	var width := unit(tower_width_units)
	var depth := unit(tower_depth_units)
	var roof_y := unit(floor_height_units) * floors_count

	var roof_thickness := 0.3
	var roof_size := Vector3(width, roof_thickness, depth)

	_create_static_box(
		"Generated_Roof",
		Vector3(0.0, roof_y - roof_thickness / 2.0, 0.0),
		roof_size
	)
	pass

func _build_stairs() -> void:
	if floors_count <= 1:
		return

	for floor_index in range(floors_count - 1):
		_build_stair_run(floor_index)


#func _build_interior() -> void:
	#if interior_scene == null:
		#return
#
	#var rotation_y := 0.0
#
	#match interior_orientation:
		#0: # North
			#rotation_y = 0.0
		#1: # East
			#rotation_y = 90.0
		#2: # South
			#rotation_y = 180.0
		#3: # West
			#rotation_y = -90.0
#
	#spawn_scene(
		#interior_scene,
		#"TowerInterior",
		#Vector3.ZERO,
		#rotation_y
	#)
	#pass

func _build_parapet() -> void:
	if not generate_parapet:
		return

	var width := unit(tower_width_units)
	var depth := unit(tower_depth_units)
	var roof_y := unit(floor_height_units) * floors_count

	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)
	var overhang := unit(parapet_overhang_units)

	var outer_width := width + overhang * 2.0
	var outer_depth := depth + overhang * 2.0

	var half_outer_width := outer_width / 2.0
	var half_outer_depth := outer_depth / 2.0

	var y := roof_y + parapet_height / 2.0

	# North parapet
	_create_static_box(
		"Parapet_North",
		Vector3(0.0, y, -half_outer_depth + parapet_thickness / 2.0),
		Vector3(outer_width, parapet_height, parapet_thickness)
	)

	# South parapet
	_create_static_box(
		"Parapet_South",
		Vector3(0.0, y, half_outer_depth - parapet_thickness / 2.0),
		Vector3(outer_width, parapet_height, parapet_thickness)
	)

	# East parapet
	_create_static_box(
		"Parapet_East",
		Vector3(half_outer_width - parapet_thickness / 2.0, y, 0.0),
		Vector3(parapet_thickness, parapet_height, outer_depth)
	)

	# West parapet
	_create_static_box(
		"Parapet_West",
		Vector3(-half_outer_width + parapet_thickness / 2.0, y, 0.0),
		Vector3(parapet_thickness, parapet_height, outer_depth)
	)
	pass
	
	
func _build_merlons() -> void:
	if not generate_merlons:
		return

	var width := unit(tower_width_units)
	var depth := unit(tower_depth_units)
	var roof_y := unit(floor_height_units) * floors_count

	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)
	var overhang := unit(parapet_overhang_units)

	var merlon_height := unit(merlon_height_units)
	var merlon_depth := unit(merlon_depth_units)

	var outer_width := width + overhang * 2.0
	var outer_depth := depth + overhang * 2.0

	var half_outer_width := outer_width / 2.0
	var half_outer_depth := outer_depth / 2.0

	var y := roof_y + parapet_height + merlon_height / 2.0

	var inset := parapet_thickness / 2.0

	_build_merlons_on_side(
		"North",
		merlons_per_side,
		Vector3(0.0, y, -half_outer_depth + inset),
		true
	)

	_build_merlons_on_side(
		"South",
		merlons_per_side,
		Vector3(0.0, y, half_outer_depth - inset),
		true
	)

	_build_merlons_on_side(
		"East",
		merlons_per_side,
		Vector3(half_outer_width - inset, y, 0.0),
		false
	)

	_build_merlons_on_side(
		"West",
		merlons_per_side,
		Vector3(-half_outer_width + inset, y, 0.0),
		false
	)
	pass


func _build_merlons_on_side(
	side_name: String,
	count: int,
	center: Vector3,
	along_x: bool
) -> void:
	var width := unit(tower_width_units) + unit(parapet_overhang_units) * 2.0
	var depth := unit(tower_depth_units) + unit(parapet_overhang_units) * 2.0

	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_depth := unit(merlon_depth_units)

	var side_length := width if along_x else depth
	var usable_length := side_length - merlon_width
	var spacing := usable_length / float(count + 1)

	for i in range(count):
		var pos := center
		var offset := -usable_length / 2.0 + spacing * float(i + 1)

		var size: Vector3

		if along_x:
			pos.x += offset
			size = Vector3(merlon_width, merlon_height, merlon_depth)
		else:
			pos.z += offset
			size = Vector3(merlon_depth, merlon_height, merlon_width)

		_create_static_box(
			"Merlon_%s_%d" % [side_name, i],
			pos,
			size
		)
	pass
# ------------------------------------------------------------
# Wall Helpers
# ------------------------------------------------------------

func _build_wall_side(
	side_name: String,
	piece_count: int,
	side_center: Vector3,
	rotation_y: float,
	opening_type: int
) -> void:
	var spacing := unit(wall_piece_width_units)
	var start_offset := -float(piece_count - 1) * spacing / 2.0
	var center_index: int = piece_count / 2

	for i in range(1, piece_count - 1):
		var local_offset := start_offset + float(i) * spacing
		var pos := side_center

		if side_name == "North" or side_name == "South":
			pos.x += local_offset
		else:
			pos.z += local_offset

		var scene_to_use := wall_scene
		var piece_label := "Wall"

		if i == center_index:
			match opening_type:
				TowerFloorOpenings.OpeningType.DOOR:
					if wall_door_scene != null:
						scene_to_use = wall_door_scene
						piece_label = "Door"

				TowerFloorOpenings.OpeningType.WINDOW:
					if wall_window_scene != null:
						scene_to_use = wall_window_scene
						piece_label = "Window"

				TowerFloorOpenings.OpeningType.WALL:
					scene_to_use = wall_scene
					piece_label = "Wall"

		spawn_scene(
			scene_to_use,
			"%s_%s_%d" % [side_name, piece_label, i],
			pos,
			rotation_y
		)
		pass
		
# ------------------------------------------------------------
# Auto-Generated Stairs
# ------------------------------------------------------------

func build_stairs() -> void:
	if floors_count <= 1:
		return

	for floor_index in range(floors_count - 1):
		_build_stair_run(floor_index)


func _build_stair_run(floor_index: int) -> void:
	var start_y := unit(floor_height_units) * floor_index
	var target_height := unit(floor_height_units)

	var step_height := unit(stair_step_height_units)
	var step_depth := unit(stair_step_depth_units)
	var stair_width := unit(stair_width_units)

	var step_count: int = max(1, int(ceil(target_height / step_height)))

	var start_x := unit(stair_offset_x_units)
	var start_z := unit(stair_offset_z_units)

	for i in step_count:
		var step_y := start_y + step_height * float(i) + step_height / 2.0
		var step_z := start_z - step_depth * float(i)
		var step_x := start_x

		var step_size := Vector3(stair_width, step_height, step_depth)

		_create_static_box(
			"Stair_%d_%d" % [floor_index, i],
			Vector3(step_x, step_y, step_z),
			step_size
		)


func _create_static_box( box_name: String, position: Vector3, size: Vector3 ) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = box_name
	body.position = position

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"

	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh

	var collision := CollisionShape3D.new()
	collision.name = "Collision"

	var box_shape := BoxShape3D.new()
	box_shape.size = size
	collision.shape = box_shape

	body.add_child(mesh_instance)
	body.add_child(collision)

	var root := ensure_generated_root()
	root.add_child(body)

	if Engine.is_editor_hint():
		var scene_root := get_tree().edited_scene_root
		body.owner = scene_root
		mesh_instance.owner = scene_root
		collision.owner = scene_root

	return body


func _get_floor_openings(floor_index: int) -> TowerFloorOpenings:
	_sync_floor_openings()
	return floor_openings[floor_index]


func _sync_floor_openings() -> void:
	while floor_openings.size() < floors_count:
		var new_openings := TowerFloorOpenings.new()
		new_openings.resource_local_to_scene = true
		floor_openings.append(new_openings)

	while floor_openings.size() > floors_count:
		floor_openings.pop_back()

	_connect_floor_opening_signals()
	pass


func _connect_floor_opening_signals() -> void:
	for openings in _connected_opening_resources:
		if openings != null and openings.changed.is_connected(_on_floor_openings_changed):
			openings.changed.disconnect(_on_floor_openings_changed)

	_connected_opening_resources.clear()

	for openings in floor_openings:
		if openings == null:
			continue

		if not openings.changed.is_connected(_on_floor_openings_changed):
			openings.changed.connect(_on_floor_openings_changed)

		_connected_opening_resources.append(openings)
	pass

func _on_floor_openings_changed() -> void:
	if Engine.is_editor_hint():
		rebuild()
	pass
