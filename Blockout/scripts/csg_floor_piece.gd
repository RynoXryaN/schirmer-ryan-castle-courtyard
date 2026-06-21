@tool
class_name CSGFloorPiece
extends CSGPieceBase


#region /// Exported Variables: Floor

@export var floor_width_units: int = 15:
	set(value):
		floor_width_units = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_depth_units: int = 20:
	set(value):
		floor_depth_units = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_thickness_units: float = 0.125:
	set(value):
		floor_thickness_units = safe_float(value, 0.025)
		if auto_update:
			update_piece()

@export var top_surface_at_zero: bool = true:
	set(value):
		top_surface_at_zero = value
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	var floor := get_node_or_null("Floor") as CSGBox3D
	if floor == null:
		return

	var floor_width := unit(floor_width_units)
	var floor_depth := unit(floor_depth_units)
	var floor_thickness := unit(floor_thickness_units)

	floor.size = Vector3(floor_width, floor_thickness, floor_depth)

	if top_surface_at_zero:
		floor.position.y = -floor_thickness / 2.0
	else:
		floor.position.y = floor_thickness / 2.0

#endregion
