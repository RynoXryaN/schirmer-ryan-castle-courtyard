@tool
class_name CSGWallPiece
extends CSGPieceBase


#region /// Exported Variables

@export var wall_length: float = 20.0:
	set(value):
		wall_length = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_height: float = 8.0:
	set(value):
		wall_height = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_thickness: float = 1.0:
	set(value):
		wall_thickness = safe_float(value)
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

	wall.size = Vector3(wall_length, wall_height, wall_thickness)

	if bottom_at_zero:
		wall.position.y = wall_height / 2.0
	else:
		wall.position.y = 0.0

#endregion
