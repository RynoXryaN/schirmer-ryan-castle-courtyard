@tool
class_name CSGCornerWallPiece
extends CSGPieceBase


#region /// Exported Variables

@export var corner_size: float = 4.0:
	set(value):
		corner_size = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_length: float = 6.0:
	set(value):
		wall_length = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_height: float = 8.0:
	set(value):
		wall_height = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_thickness: float = 1.5:
	set(value):
		wall_thickness = safe_float(value)
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	var corner := get_node_or_null("CornerBlock") as CSGBox3D
	var wall_a := get_node_or_null("Wall_A") as CSGBox3D
	var wall_b := get_node_or_null("Wall_B") as CSGBox3D

	if corner == null or wall_a == null or wall_b == null:
		return

	corner.size = Vector3(corner_size, wall_height, corner_size)
	corner.position = Vector3(0.0, wall_height / 2.0, 0.0)

	wall_a.size = Vector3(wall_length, wall_height, wall_thickness)
	wall_a.position = Vector3(
		corner_size / 2.0 + wall_length / 2.0,
		wall_height / 2.0,
		0.0
	)

	wall_b.size = Vector3(wall_thickness, wall_height, wall_length)
	wall_b.position = Vector3(
		0.0,
		wall_height / 2.0,
		corner_size / 2.0 + wall_length / 2.0
	)

#endregion
