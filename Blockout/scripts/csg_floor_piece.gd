@tool
class_name CSGFloorPiece
extends CSGPieceBase

#region /// Exported Variables

@export var floor_width: float = 40.0:
	set(value):
		floor_width = safe_float(value)
		if auto_update:
			update_piece()

@export var floor_depth: float = 50.0:
	set(value):
		floor_depth = safe_float(value)
		if auto_update:
			update_piece()

@export var floor_thickness: float = 0.5:
	set(value):
		floor_thickness = safe_float(value)
		if auto_update:
			update_piece()

@export var top_surface_at_zero: bool = true:
	set(value):
		top_surface_at_zero = value
		if auto_update:
			update_piece()
			
#endregion

@onready var floor: CSGBox3D = $Floor

#region Virtual Functions

func update_piece() -> void:
	if floor == null:
		return

	floor.size = Vector3(floor_width, floor_thickness, floor_depth)

	if top_surface_at_zero:
		floor.position.y = -floor_thickness / 2.0
	else:
		floor.position.y = floor_thickness / 2.0
		
#endregion
