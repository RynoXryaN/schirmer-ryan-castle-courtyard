@tool
class_name CSGCastleWallSection
extends CSGPieceBase


#region /// Exported Variables: Wall

@export_category( "Wall" )

@export var wall_length_units: int = 4:
	set(value):
		wall_length_units = safe_int(value)
		if auto_update:
			update_piece()

@export var wall_height_units: int = 2:
	set(value):
		wall_height_units = safe_int(value)
		if auto_update:
			update_piece()

@export var wall_thickness_units: float = 0.25:
	set(value):
		wall_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Wall Walk

@export_category( "Wall Walk" )

@export var wall_walk_depth_units: float = 0.75:
	set(value):
		wall_walk_depth_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var wall_walk_thickness_units: float = 0.1:
	set(value):
		wall_walk_thickness_units = safe_float(value, 0.025)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Parapet

@export_category( "Parapet" )

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

@export_category( "Merlon" )

@export var merlon_count: int = 4:
	set(value):
		merlon_count = max(value, 0)
		if auto_update:
			update_piece()

@export var merlon_width_units: float = 0.35:
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


#region /// Exported Variables: Placement

@export_category( "Other Variables" )

@export var bottom_at_zero: bool = true:
	set(value):
		bottom_at_zero = value
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	_update_wall()
	_update_wall_walk()
	_update_parapet()
	_update_merlons()


func _update_wall() -> void:
	var wall := get_node_or_null("Wall") as CSGBox3D
	if wall == null:
		return

	var wall_length := unit(wall_length_units)
	var wall_height := unit(wall_height_units)
	var wall_thickness := unit(wall_thickness_units)

	wall.size = Vector3(wall_length, wall_height, wall_thickness)

	if bottom_at_zero:
		wall.position.y = wall_height / 2.0
	else:
		wall.position.y = 0.0


func _update_wall_walk() -> void:
	var wall_walk := get_node_or_null("WallWalk") as CSGBox3D
	if wall_walk == null:
		return

	var wall_length := unit(wall_length_units)
	var wall_height := unit(wall_height_units)
	var wall_thickness := unit(wall_thickness_units)

	var wall_walk_depth := unit(wall_walk_depth_units)
	var wall_walk_thickness := unit(wall_walk_thickness_units)

	wall_walk.size = Vector3(wall_length, wall_walk_thickness, wall_walk_depth)

	var back_of_wall_z := -wall_thickness / 2.0
	var wall_walk_center_z := back_of_wall_z - wall_walk_depth / 2.0

	wall_walk.position = Vector3(
		0.0,
		wall_height - wall_walk_thickness / 2.0,
		wall_walk_center_z
	)


func _update_parapet() -> void:
	var parapet := get_node_or_null("Parapet") as CSGBox3D
	if parapet == null:
		return

	var wall_length := unit(wall_length_units)
	var wall_height := unit(wall_height_units)
	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)

	parapet.size = Vector3(wall_length, parapet_height, parapet_thickness)

	# Bottom of parapet sits exactly on top of main wall.
	parapet.position = Vector3( 0.0, wall_height + parapet_height / 2.0, 0.0)


func _update_merlons() -> void:
	var merlons := get_node_or_null("Merlons") as Node3D
	if merlons == null:
		return

	for child in merlons.get_children():
		child.free()

	if merlon_count <= 0:
		return

	var wall_length := unit(wall_length_units)
	var wall_height := unit(wall_height_units)
	var parapet_height := unit(parapet_height_units)

	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_thickness := unit(merlon_thickness_units)

	var spacing := wall_length / float(merlon_count)
	var start_x := -wall_length / 2.0 + spacing / 2.0

	# Bottom of merlons sits exactly on top of parapet.
	var merlon_y := wall_height + parapet_height + merlon_height / 2.0

	for i in merlon_count:
		var merlon := CSGBox3D.new()
		merlon.name = "Merlon_%02d" % i
		merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
		merlon.position = Vector3(
			start_x + spacing * i,
			merlon_y,
			0.0
		)

		merlons.add_child(merlon)
		merlon.owner = get_tree().edited_scene_root

#endregion
