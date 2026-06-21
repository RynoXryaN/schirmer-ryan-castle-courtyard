@tool
class_name CSGDrawbridgePiece
extends CSGPieceBase


#region /// Exported Variables: Drawbridge

@export var bridge_width_units: int = 2:
	set(value):
		bridge_width_units = safe_int(value)
		if auto_update:
			update_piece()

@export var bridge_length_units: int = 3:
	set(value):
		bridge_length_units = safe_int(value)
		if auto_update:
			update_piece()

@export var bridge_thickness_units: float = 0.1:
	set(value):
		bridge_thickness_units = safe_float(value, 0.025)
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

	var bridge_width := unit(bridge_width_units)
	var bridge_length := unit(bridge_length_units)
	var bridge_thickness := unit(bridge_thickness_units)

	bridge.size = Vector3(bridge_width, bridge_thickness, bridge_length)

	if top_surface_at_zero:
		bridge.position.y = -bridge_thickness / 2.0
	else:
		bridge.position.y = bridge_thickness / 2.0

#endregion
