@tool
class_name CSGDrawbridgePiece
extends CSGPieceBase


#region /// Exported Variables

@export var bridge_width: float = 6.0:
	set(value):
		bridge_width = safe_float(value)
		if auto_update:
			update_piece()

@export var bridge_length: float = 12.0:
	set(value):
		bridge_length = safe_float(value)
		if auto_update:
			update_piece()

@export var bridge_thickness: float = 0.4:
	set(value):
		bridge_thickness = safe_float(value)
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
	var bridge := get_node_or_null("Drawbridge") as CSGBox3D
	if bridge == null:
		return

	bridge.size = Vector3(bridge_width, bridge_thickness, bridge_length)

	if top_surface_at_zero:
		bridge.position.y = -bridge_thickness / 2.0
	else:
		bridge.position.y = bridge_thickness / 2.0

#endregion
