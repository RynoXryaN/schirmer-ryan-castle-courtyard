@tool
class_name CSGTowerPiece
extends CSGPieceBase


#region /// Exported Variables

@export var tower_radius: float = 4.0:
	set(value):
		tower_radius = safe_float(value)
		if auto_update:
			update_piece()

@export var tower_height: float = 10.0:
	set(value):
		tower_height = safe_float(value)
		if auto_update:
			update_piece()

@export var tower_sides: int = 16:
	set(value):
		tower_sides = max(value, 3)
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
	var tower := get_node_or_null("Tower") as CSGCylinder3D
	if tower == null:
		return

	tower.radius = tower_radius
	tower.height = tower_height
	tower.sides = tower_sides

	if bottom_at_zero:
		tower.position.y = tower_height / 2.0
	else:
		tower.position.y = 0.0

#endregion
