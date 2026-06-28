@tool
extends SmartBuildPiece
class_name SmartCastleWall


# ------------------------------------------------------------
# Wall Asset Scenes
# ------------------------------------------------------------

@export_group("Wall Asset Scenes")
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

@export var wall_door_scene: PackedScene:
	set(value):
		wall_door_scene = value
		if Engine.is_editor_hint():
			rebuild()

@export var end_cap_scene: PackedScene:
	set(value):
		end_cap_scene = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Wall Layout
# ------------------------------------------------------------

@export_group("Wall Layout")
@export var wall_length_segments: int = 5:
	set(value):
		wall_length_segments = max(1, value)
		_sync_segments()
		if Engine.is_editor_hint():
			rebuild()

@export var wall_piece_width_units: float = 1.0:
	set(value):
		wall_piece_width_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var floors_count: int = 1:
	set(value):
		floors_count = max(1, value)
		if Engine.is_editor_hint():
			rebuild()

@export var floor_height_units: float = 1.0:
	set(value):
		floor_height_units = max(0.1, value)
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Segment Options
# ------------------------------------------------------------

@export_group("Wall Segments")
@export var segments: Array[CastleWallSegmentOption] = []:
	set(value):
		segments = value
		_sync_segments()
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# End Caps
# ------------------------------------------------------------

@export_group("End Caps")
@export var generate_end_caps: bool = false:
	set(value):
		generate_end_caps = value
		if Engine.is_editor_hint():
			rebuild()

@export var end_cap_offset_units: float = 1.0:
	set(value):
		end_cap_offset_units = value
		if Engine.is_editor_hint():
			rebuild()

@export var left_end_cap_rotation_y: float = 0.0:
	set(value):
		left_end_cap_rotation_y = value
		if Engine.is_editor_hint():
			rebuild()

@export var right_end_cap_rotation_y: float = 180.0:
	set(value):
		right_end_cap_rotation_y = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Top Cap / Wall Walk
# ------------------------------------------------------------

@export_group("Top Cap / Wall Walk")
@export var generate_top_cap: bool = true:
	set(value):
		generate_top_cap = value
		if Engine.is_editor_hint():
			rebuild()

@export var top_cap_thickness: float = 0.25:
	set(value):
		top_cap_thickness = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var top_cap_depth_units: float = 0.45:
	set(value):
		top_cap_depth_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var top_cap_overhang_units: float = 0.00:
	set(value):
		top_cap_overhang_units = max(0.0, value)
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

@export var parapet_height_units: float = 0.25:
	set(value):
		parapet_height_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var parapet_thickness_units: float = 0.18:
	set(value):
		parapet_thickness_units = max(0.05, value)
		if Engine.is_editor_hint():
			rebuild()

@export var generate_front_parapet: bool = true:
	set(value):
		generate_front_parapet = value
		if Engine.is_editor_hint():
			rebuild()

@export var generate_back_parapet: bool = true:
	set(value):
		generate_back_parapet = value
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

@export var merlon_count: int = 5:
	set(value):
		merlon_count = max(1, value)
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

@export var generate_front_merlons: bool = true:
	set(value):
		generate_front_merlons = value
		if Engine.is_editor_hint():
			rebuild()

@export var generate_back_merlons: bool = true:
	set(value):
		generate_back_merlons = value
		if Engine.is_editor_hint():
			rebuild()


# ------------------------------------------------------------
# Internal
# ------------------------------------------------------------

var _connected_segment_resources: Array[CastleWallSegmentOption] = []


func _ready() -> void:
	ensure_generated_root()
	_sync_segments()


func rebuild() -> void:
	_sync_segments()
	clear_generated()

	_build_wall_segments()
	_build_end_caps()
	_build_top_cap()
	_build_parapet()
	_build_merlons()
	
	
func _sync_segments() -> void:
	while segments.size() < wall_length_segments:
		var new_segment := CastleWallSegmentOption.new()
		new_segment.resource_local_to_scene = true
		segments.append(new_segment)

	while segments.size() > wall_length_segments:
		segments.pop_back()

	_connect_segment_signals()


func _connect_segment_signals() -> void:
	for segment in _connected_segment_resources:
		if segment != null and segment.changed.is_connected(_on_segment_changed):
			segment.changed.disconnect(_on_segment_changed)

	_connected_segment_resources.clear()

	for segment in segments:
		if segment == null:
			continue

		if not segment.changed.is_connected(_on_segment_changed):
			segment.changed.connect(_on_segment_changed)

		_connected_segment_resources.append(segment)


func _on_segment_changed() -> void:
	if Engine.is_editor_hint():
		rebuild()
		
		
func _build_wall_segments() -> void:
	var spacing := unit(wall_piece_width_units)
	var start_x := -float(wall_length_segments - 1) * spacing / 2.0
	var floor_height := unit(floor_height_units)

	for floor_index in range(floors_count):
		var y := floor_height * floor_index

		for i in range(wall_length_segments):
			var segment := segments[i]
			var scene_to_use := _get_scene_for_segment(segment)
			var label := _get_label_for_segment(segment)

			spawn_scene(
				scene_to_use,
				"%s_%d_Floor_%d" % [label, i, floor_index],
				Vector3(start_x + float(i) * spacing, y, 0.0),
				0.0
			)


func _get_scene_for_segment(segment: CastleWallSegmentOption) -> PackedScene:
	if segment == null:
		return wall_scene

	match segment.segment_type:
		CastleWallSegmentOption.SegmentType.DOOR:
			if wall_door_scene != null:
				return wall_door_scene

		CastleWallSegmentOption.SegmentType.WINDOW:
			if wall_window_scene != null:
				return wall_window_scene

		CastleWallSegmentOption.SegmentType.WALL:
			return wall_scene

	return wall_scene


func _get_label_for_segment(segment: CastleWallSegmentOption) -> String:
	if segment == null:
		return "Wall"

	match segment.segment_type:
		CastleWallSegmentOption.SegmentType.DOOR:
			return "Door"
		CastleWallSegmentOption.SegmentType.WINDOW:
			return "Window"
		_:
			return "Wall"
			

func _build_end_caps() -> void:
	if not generate_end_caps:
		return

	if end_cap_scene == null:
		return

	var spacing := unit(wall_piece_width_units)
	var offset := unit(end_cap_offset_units)
	var half_length := float(wall_length_segments - 1) * spacing / 2.0
	var floor_height := unit(floor_height_units)

	for floor_index in range(floors_count):
		var y := floor_height * floor_index

		spawn_scene(
			end_cap_scene,
			"EndCap_Left_Floor_%d" % floor_index,
			Vector3(-half_length - offset, y, 0.0),
			left_end_cap_rotation_y
		)

		spawn_scene(
			end_cap_scene,
			"EndCap_Right_Floor_%d" % floor_index,
			Vector3(half_length + offset, y, 0.0),
			right_end_cap_rotation_y
		)
		pass
		
		
func _build_top_cap() -> void:
	if not generate_top_cap:
		return

	var length := unit(wall_length_segments * wall_piece_width_units)
	var depth := unit(top_cap_depth_units)
	var overhang := unit(top_cap_overhang_units)
	var thickness := top_cap_thickness

	var floor_height := unit(floor_height_units)
	var wall_top_y := floor_height * floors_count

	# Auto-offset:
	# Places the FRONT edge of the wall walk at z = 0,
	# so it begins directly over the center of the wall.
	var wall_walk_center_z := depth / 2.0 + wall_piece_width_units / 2.0

	var cap_size := Vector3(
		length + overhang * 2.0,
		thickness,
		depth
	)

	_create_static_box(
		"Generated_WallWalk",
		Vector3(0.0, wall_top_y - thickness / 2.0, wall_walk_center_z),
		cap_size
	)
	pass
	

func _build_parapet() -> void:
	if not generate_parapet:
		return

	var length := unit(wall_length_segments * wall_piece_width_units)
	var overhang := unit(top_cap_overhang_units)

	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)

	var floor_height := unit(floor_height_units)
	var wall_top_y := floor_height * floors_count
	var y := wall_top_y + parapet_height / 2.0

	var total_length := length + overhang * 2.0

	# Auto-offset:
	# Places the BACK edge of the parapet at z = 0,
	# so it butts directly against the wall walk.
	var front_parapet_z := -parapet_thickness / 2.0
	var back_parapet_z := parapet_thickness / 2.0 + unit(top_cap_depth_units)

	if generate_front_parapet:
		_create_static_box(
			"Parapet_Front",
			Vector3(0.0, y, front_parapet_z),
			Vector3(total_length, parapet_height, parapet_thickness)
		)

	if generate_back_parapet:
		_create_static_box(
			"Parapet_Back",
			Vector3(0.0, y, back_parapet_z),
			Vector3(total_length, parapet_height, parapet_thickness)
		)
	pass


func _build_merlons() -> void:
	if not generate_merlons:
		return

	var length := unit(wall_length_segments * wall_piece_width_units)

	var floor_height := unit(floor_height_units)
	var wall_top_y := floor_height * floors_count

	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)
	var merlon_height := unit(merlon_height_units)

	var y := wall_top_y + parapet_height + merlon_height / 2.0

	var front_merlon_z := -parapet_thickness / 2.0
	var back_merlon_z := parapet_thickness / 2.0 + unit(top_cap_depth_units)

	if generate_front_merlons:
		_build_merlons_on_line(
			"Front",
			Vector3(0.0, y, front_merlon_z),
			length
		)

	if generate_back_merlons:
		_build_merlons_on_line(
			"Back",
			Vector3(0.0, y, back_merlon_z),
			length
		)
		pass

func _build_merlons_on_line(side_name: String, center: Vector3, length: float) -> void:
	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_depth := unit(merlon_depth_units)

	var usable_length: float = max(merlon_width, length - merlon_width)
	var spacing: float = usable_length / float(merlon_count + 1)

	for i in range(merlon_count):
		var x : float = -usable_length / 2.0 + spacing * float(i + 1)

		_create_static_box(
			"Merlon_%s_%d" % [side_name, i],
			Vector3(center.x + x, center.y, center.z),
			Vector3(merlon_width, merlon_height, merlon_depth)
		)
		pass


func clear_generated() -> void:
	var root := get_node_or_null("Generated") as Node3D

	if root == null:
		return

	for child in root.get_children():
		if Engine.is_editor_hint():
			child.free()
		else:
			child.queue_free()
	pass
