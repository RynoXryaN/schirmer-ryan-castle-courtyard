@tool
class_name CSGGatehouseSection
extends CSGPieceBase


#region /// Exported Variables: Gatehouse

@export_category("Gatehouse")

@export var width_units: float = 3.0:
	set(value):
		width_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var depth_units: float = 2.0:
	set(value):
		depth_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var floor_count: int = 2:
	set(value):
		floor_count = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_height_units: float = 1.0:
	set(value):
		floor_height_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Gate Opening

@export_category("Gate Opening")

@export var gate_width_units: float = 1.5:
	set(value):
		gate_width_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var gate_height_units: float = 1.5:
	set(value):
		gate_height_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var gate_depth_units: float = 2.5:
	set(value):
		gate_depth_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var arch_sides: int = 16:
	set(value):
		arch_sides = max(value, 4)
		if auto_update:
			update_piece()

#endregion

@export_category("Second Floor Hallway")

@export var hallway_enabled: bool = true:
	set(value):
		hallway_enabled = value
		if auto_update:
			update_piece()

@export var hallway_width_units: float = 0.75:
	set(value):
		hallway_width_units = safe_float(value, 0.1)
		if auto_update:
			update_piece()

@export var hallway_height_units: float = 0.75:
	set(value):
		hallway_height_units = safe_float(value, 0.1)
		if auto_update:
			update_piece()

#region /// Exported Variables: Floors / Roof

@export_category("Floors / Roof")

@export var upper_floor_enabled: bool = true:
	set(value):
		upper_floor_enabled = value
		if auto_update:
			update_piece()

@export var upper_floor_thickness_units: float = 0.1:
	set(value):
		upper_floor_thickness_units = safe_float(value, 0.025)
		if auto_update:
			update_piece()

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

@export var merlon_count_front_back: int = 4:
	set(value):
		merlon_count_front_back = max(value, 0)
		if auto_update:
			update_piece()

@export var merlon_count_sides: int = 3:
	set(value):
		merlon_count_sides = max(value, 0)
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
	_update_body()
	_update_openings()
	#_update_hallway()
	#_update_upper_floor()
	_update_roof()
	_update_parapet()
	_update_merlons()
	pass


func _update_body() -> void:
	var body := get_node_or_null("Body") as CSGBox3D
	if body == null:
		return

	var width := unit(width_units)
	var depth := unit(depth_units)
	var height := unit(floor_count * floor_height_units)

	body.size = Vector3(width, height, depth)
	body.position.y = height / 2.0
	pass


func _update_openings() -> void:
	var body := get_node_or_null("Body") as CSGBox3D
	if body == null:
		return

	for child in body.get_children():
		child.queue_free()

	var width := unit(gate_width_units)
	var height := unit(gate_height_units)
	var depth := unit(gate_depth_units)
	var body_height := unit(floor_count * floor_height_units)

	var cutout := CSGPolygon3D.new()
	cutout.name = "Gate_Arch_Cutout"
	cutout.operation = CSGShape3D.OPERATION_SUBTRACTION
	cutout.depth = depth
	cutout.polygon = _make_arch_polygon(width, height)

	cutout.position = Vector3(0.0, height / 2.0 - body_height / 2.0, depth / 2.0)

	body.add_child(cutout)
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


func _update_upper_floor() -> void:
	var interior := get_node_or_null("Interior") as Node3D
	if interior == null:
		return

	for child in interior.get_children():
		child.queue_free()

	if not upper_floor_enabled:
		return

	var width := unit(width_units)
	var depth := unit(depth_units)
	var floor_y := unit(floor_height_units)
	var floor_thickness := unit(upper_floor_thickness_units)
	var hallway_width := unit(hallway_width_units)

	var side_width := (width - hallway_width) / 2.0

	_add_box(
		interior,
		"UpperFloor_LeftWalkway",
		Vector3(side_width, floor_thickness, depth),
		Vector3(-width / 2.0 + side_width / 2.0, floor_y, 0.0)
	)

	_add_box(
		interior,
		"UpperFloor_RightWalkway",
		Vector3(side_width, floor_thickness, depth),
		Vector3(width / 2.0 - side_width / 2.0, floor_y, 0.0)
	)

	pass


func _update_hallway() -> void:
	if not hallway_enabled:
		return

	var body := get_node_or_null("Body") as CSGBox3D
	if body == null:
		return

	var hallway_width := unit(width_units) + unit(0.25) # punch all the way left/right
	var hallway_height := unit(hallway_height_units)
	var hallway_depth := unit(hallway_width_units) # thickness front/back

	var body_height := unit(floor_count * floor_height_units)

	# Center of second floor.
	var second_floor_y := unit(floor_height_units) + unit(floor_height_units) / 2.0

	var cutout := CSGBox3D.new()
	cutout.name = "Second_Floor_Hallway_Cutout"
	cutout.operation = CSGShape3D.OPERATION_SUBTRACTION

	cutout.size = Vector3(
		hallway_width,
		hallway_height,
		hallway_depth
	)

	cutout.position = Vector3(
		0.0,
		second_floor_y - body_height / 2.0,
		0.0
	)

	body.add_child(cutout)
	cutout.owner = get_tree().edited_scene_root
	pass


func _update_roof() -> void:
	var roof := get_node_or_null("Roof") as CSGBox3D
	if roof == null:
		return

	roof.visible = roof_enabled
	roof.use_collision = roof_enabled

	if not roof_enabled:
		return

	var width := unit(width_units)
	var depth := unit(depth_units)
	var height := unit(floor_count * floor_height_units)
	var roof_thickness := unit(roof_thickness_units)

	roof.size = Vector3(width, roof_thickness, depth)
	roof.position = Vector3(0.0, height, 0.0)
	pass


func _update_parapet() -> void:
	var parapet := get_node_or_null("Parapet") as Node3D
	if parapet == null:
		return

	for child in parapet.get_children():
		child.queue_free()

	var width := unit(width_units)
	var depth := unit(depth_units)
	var height := unit(floor_count * floor_height_units)
	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)

	var y := height + parapet_height / 2.0

	_add_box(parapet, "FrontParapet", Vector3(width, parapet_height, parapet_thickness), Vector3(0.0, y, -depth / 2.0 + parapet_thickness / 2.0))
	_add_box(parapet, "RearParapet", Vector3(width, parapet_height, parapet_thickness), Vector3(0.0, y, depth / 2.0 - parapet_thickness / 2.0))
	_add_box(parapet, "LeftParapet", Vector3(parapet_thickness, parapet_height, depth), Vector3(-width / 2.0 + parapet_thickness / 2.0, y, 0.0))
	_add_box(parapet, "RightParapet", Vector3(parapet_thickness, parapet_height, depth), Vector3(width / 2.0 - parapet_thickness / 2.0, y, 0.0))
	pass


func _update_merlons() -> void:
	var merlons := get_node_or_null("Merlons") as Node3D
	if merlons == null:
		return

	for child in merlons.get_children():
		child.queue_free()

	var width := unit(width_units)
	var depth := unit(depth_units)
	var height := unit(floor_count * floor_height_units)
	var parapet_height := unit(parapet_height_units)

	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_thickness := unit(merlon_thickness_units)

	var y := height + parapet_height + merlon_height / 2.0

	_add_merlon_row(merlons, "Front", merlon_count_front_back, width, depth, y, merlon_width, merlon_height, merlon_thickness)
	_add_merlon_row(merlons, "Rear", merlon_count_front_back, width, depth, y, merlon_width, merlon_height, merlon_thickness)
	_add_merlon_row(merlons, "Left", merlon_count_sides, width, depth, y, merlon_width, merlon_height, merlon_thickness)
	_add_merlon_row(merlons, "Right", merlon_count_sides, width, depth, y, merlon_width, merlon_height, merlon_thickness)
	pass


func _add_merlon_row(parent: Node3D, side_name: String, count: int, width: float, depth: float, y: float, merlon_width: float, merlon_height: float, merlon_thickness: float) -> void:
	if count <= 0:
		return

	var span := width

	if side_name == "Left" or side_name == "Right":
		span = depth

	var spacing := span / float(count)
	var start := -span / 2.0 + spacing / 2.0

	for i in count:
		var merlon := CSGBox3D.new()
		merlon.name = "%s_Merlon_%02d" % [side_name, i]

		match side_name:
			"Front":
				merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
				merlon.position = Vector3(start + spacing * i, y, -depth / 2.0 + merlon_thickness / 2.0)
			"Rear":
				merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
				merlon.position = Vector3(start + spacing * i, y, depth / 2.0 - merlon_thickness / 2.0)
			"Left":
				merlon.size = Vector3(merlon_thickness, merlon_height, merlon_width)
				merlon.position = Vector3(-width / 2.0 + merlon_thickness / 2.0, y, start + spacing * i)
			"Right":
				merlon.size = Vector3(merlon_thickness, merlon_height, merlon_width)
				merlon.position = Vector3(width / 2.0 - merlon_thickness / 2.0, y, start + spacing * i)

		parent.add_child(merlon)
		merlon.owner = get_tree().edited_scene_root

	pass


func _add_box(parent: Node3D, box_name: String, box_size: Vector3, box_position: Vector3) -> void:
	var box := CSGBox3D.new()
	box.name = box_name
	box.size = box_size
	box.position = box_position
	parent.add_child(box)
	box.owner = get_tree().edited_scene_root
	pass

#endregion
