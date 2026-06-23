@tool
extends SmartBuildPiece
class_name SmartGatehouse


# ------------------------------------------------------------
# Asset Scenes
# ------------------------------------------------------------

@export_group("Gatehouse Asset Scenes")
@export var wall_scene: PackedScene:
	set(value):
		wall_scene = value
		if Engine.is_editor_hint():
			rebuild()

@export var wall_window_scene: PackedScene:
	set(value):
		wall_window_scene = value
		if Engine.is_editor_hint():
			rebuild()

@export var gate_doorway_scene: PackedScene:
	set(value):
		gate_doorway_scene = value
		if Engine.is_editor_hint():
			rebuild()

@export var wall_corner_scene: PackedScene:
	set(value):
		wall_corner_scene = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Main Shape
# ------------------------------------------------------------

@export_group("Gatehouse Shape")
@export var floors_count: int = 2:
	set(value):
		floors_count = max(2, value)
		if Engine.is_editor_hint():
			rebuild()

@export var floor_height_units: float = 1.0:
	set(value):
		floor_height_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var piece_width_units: float = 1.0:
	set(value):
		piece_width_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var depth_units: float = 1.0:
	set(value):
		depth_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var bridge_floor_index: int = 1:
	set(value):
		bridge_floor_index = max(1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var use_bridge_windows: bool = true:
	set(value):
		use_bridge_windows = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Asset Tuning
# ------------------------------------------------------------

@export_group("Asset Tuning")
@export var asset_visual_scale: Vector3 = Vector3.ONE:
	set(value):
		asset_visual_scale = value
		if Engine.is_editor_hint():
			rebuild()

@export var side_wall_rotation_offset: float = 0.0:
	set(value):
		side_wall_rotation_offset = value
		if Engine.is_editor_hint():
			rebuild()

@export var front_back_rotation_offset: float = 0.0:
	set(value):
		front_back_rotation_offset = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Wall Walk
# ------------------------------------------------------------

@export_group("Wall Walk")
@export var generate_wall_walk: bool = true:
	set(value):
		generate_wall_walk = value
		if Engine.is_editor_hint():
			rebuild()

@export var wall_walk_thickness: float = 0.20:
	set(value):
		wall_walk_thickness = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var wall_walk_overhang_units: float = 0.10:
	set(value):
		wall_walk_overhang_units = max(0.0, value)
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Parapet
# ------------------------------------------------------------

@export_group("Parapet")
@export var generate_parapet: bool = true:
	set(value):
		generate_parapet = value
		if Engine.is_editor_hint():
			rebuild()

@export var parapet_height_units: float = 0.22:
	set(value):
		parapet_height_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var parapet_thickness_units: float = 0.14:
	set(value):
		parapet_thickness_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Merlons
# ------------------------------------------------------------

@export_group("Merlons")
@export var generate_merlons: bool = true:
	set(value):
		generate_merlons = value
		if Engine.is_editor_hint():
			rebuild()

@export var merlons_per_side: int = 3:
	set(value):
		merlons_per_side = max(1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var merlon_width_units: float = 0.28:
	set(value):
		merlon_width_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var merlon_height_units: float = 0.32:
	set(value):
		merlon_height_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var merlon_depth_units: float = 0.14:
	set(value):
		merlon_depth_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Runtime
# ------------------------------------------------------------

func _ready() -> void:
	ensure_generated_root()


#func rebuild() -> void:
	#clear_generated()
#
	#_build_front_face()
	#_build_back_face()
	#_build_side_walls()
	#_build_wall_walk()
	#_build_parapet()
	#_build_merlons()
	
	
#func rebuild() -> void:
	#clear_generated()
#
	#_build_front_face()
	#
	
	
func rebuild() -> void:
	clear_generated()

	_spawn_asset(
		gate_doorway_scene,
		"TEST_GateDoorway_ONLY",
		Vector3.ZERO,
		0.0
	)
	pass
# ------------------------------------------------------------
# Main Gatehouse Build
# ------------------------------------------------------------

func _build_front_face() -> void:
	_build_face("Front", -_half_depth(), 0.0 + front_back_rotation_offset)


func _build_back_face() -> void:
	_build_face("Back", _half_depth(), 180.0 + front_back_rotation_offset)


func _build_face(face_name: String, z: float, rotation_y: float) -> void:
	var spacing := unit(piece_width_units)
	var floor_height := unit(floor_height_units)

	var left_x := -spacing
	var center_x := 0.0
	var right_x := spacing

	for floor_index in range(floors_count):
		var y := floor_height * floor_index

		# Left pier
		_spawn_asset(
			wall_scene,
			"%s_LeftPier_Floor_%d" % [face_name, floor_index],
			Vector3(left_x, y, z),
			rotation_y
		)

		# Right pier
		_spawn_asset(
			wall_scene,
			"%s_RightPier_Floor_%d" % [face_name, floor_index],
			Vector3(right_x, y, z),
			rotation_y
		)

		# Center section
		if floor_index == 0:
			_spawn_asset(
				gate_doorway_scene,
				"%s_GateDoorway" % face_name,
				Vector3(center_x, y, z),
				rotation_y
			)
		elif floor_index >= bridge_floor_index:
			var bridge_scene := wall_scene
			var bridge_label := "BridgeWall"

			if use_bridge_windows and wall_window_scene != null:
				bridge_scene = wall_window_scene
				bridge_label = "BridgeWindow"

			_spawn_asset(
				bridge_scene,
				"%s_%s_Floor_%d" % [face_name, bridge_label, floor_index],
				Vector3(center_x, y, z),
				rotation_y
			)
	pass
	
	
func _build_side_walls() -> void:
	var floor_height := unit(floor_height_units)

	var left_x := -unit(piece_width_units)
	var right_x := unit(piece_width_units)

	for floor_index in range(floors_count):
		var y := floor_height * floor_index

		_spawn_asset(
			wall_scene,
			"LeftSide_Floor_%d" % floor_index,
			Vector3(left_x, y, 0.0),
			-90.0 + side_wall_rotation_offset
		)

		_spawn_asset(
			wall_scene,
			"RightSide_Floor_%d" % floor_index,
			Vector3(right_x, y, 0.0),
			90.0 + side_wall_rotation_offset
		)
	pass
	
	
# ------------------------------------------------------------
# Wall Walk / Battlements
# ------------------------------------------------------------

func _build_wall_walk() -> void:
	if not generate_wall_walk:
		return

	var width := _total_width()
	var depth := _total_depth()
	var overhang := unit(wall_walk_overhang_units)
	var top_y := _top_y()

	_create_static_box(
		"Generated_WallWalk",
		Vector3(0.0, top_y - wall_walk_thickness / 2.0, 0.0),
		Vector3(
			width + overhang * 2.0,
			wall_walk_thickness,
			depth + overhang * 2.0
		)
	)


func _build_parapet() -> void:
	if not generate_parapet:
		return

	var width := _total_width() + unit(wall_walk_overhang_units) * 2.0
	var depth := _total_depth() + unit(wall_walk_overhang_units) * 2.0

	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)
	var top_y := _top_y()
	var y := top_y + parapet_height / 2.0

	# Front
	_create_static_box(
		"Parapet_Front",
		Vector3(0.0, y, -depth / 2.0 + parapet_thickness / 2.0),
		Vector3(width, parapet_height, parapet_thickness)
	)

	# Back
	_create_static_box(
		"Parapet_Back",
		Vector3(0.0, y, depth / 2.0 - parapet_thickness / 2.0),
		Vector3(width, parapet_height, parapet_thickness)
	)

	# Left
	_create_static_box(
		"Parapet_Left",
		Vector3(-width / 2.0 + parapet_thickness / 2.0, y, 0.0),
		Vector3(parapet_thickness, parapet_height, depth)
	)

	# Right
	_create_static_box(
		"Parapet_Right",
		Vector3(width / 2.0 - parapet_thickness / 2.0, y, 0.0),
		Vector3(parapet_thickness, parapet_height, depth)
	)


func _build_merlons() -> void:
	if not generate_merlons:
		return

	var width := _total_width() + unit(wall_walk_overhang_units) * 2.0
	var depth := _total_depth() + unit(wall_walk_overhang_units) * 2.0

	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)
	var merlon_height := unit(merlon_height_units)

	var y := _top_y() + parapet_height + merlon_height / 2.0

	_build_merlon_line(
		"Front",
		Vector3(0.0, y, -depth / 2.0 + parapet_thickness / 2.0),
		width,
		true
	)

	_build_merlon_line(
		"Back",
		Vector3(0.0, y, depth / 2.0 - parapet_thickness / 2.0),
		width,
		true
	)

	_build_merlon_line(
		"Left",
		Vector3(-width / 2.0 + parapet_thickness / 2.0, y, 0.0),
		depth,
		false
	)

	_build_merlon_line(
		"Right",
		Vector3(width / 2.0 - parapet_thickness / 2.0, y, 0.0),
		depth,
		false
	)


func _build_merlon_line(
	side_name: String,
	center: Vector3,
	length: float,
	along_x: bool
) -> void:
	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_depth := unit(merlon_depth_units)

	var usable_length: float = max(merlon_width, length - merlon_width)
	var spacing: float = usable_length / float(merlons_per_side + 1)

	for i in range(merlons_per_side):
		var offset: float = -usable_length / 2.0 + spacing * float(i + 1)
		var pos := center
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
# Helpers
# ------------------------------------------------------------

func _spawn_asset(
	scene: PackedScene,
	spawn_name: String,
	position: Vector3,
	rotation_y: float
) -> Node3D:
	if scene == null:
		push_warning("Missing scene for: " + spawn_name)
		return null

	var instance := spawn_scene(
		scene,
		spawn_name,
		position,
		rotation_y
	)

	if instance != null:
		instance.scale = asset_visual_scale

	return instance


func _total_width() -> float:
	return unit(piece_width_units) * 3.0


func _total_depth() -> float:
	return unit(depth_units)


func _half_depth() -> float:
	return _total_depth() / 2.0


func _top_y() -> float:
	return unit(floor_height_units) * floors_count
