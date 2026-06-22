@tool
class_name CSGWallPiece
extends CSGPieceBase


#region /// Exported Variables: Wall

@export var wall_length_units: int = 1:
	set(value):
		wall_length_units = safe_int(value)
		if auto_update:
			update_piece()

@export var wall_height_units: int = 1:
	set(value):
		wall_height_units = safe_int(value)
		if auto_update:
			update_piece()

@export var wall_thickness_units: float = 0.25:
	set(value):
		wall_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var bottom_at_zero: bool = true:
	set(value):
		bottom_at_zero = value
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
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
	pass
	

#endregion
