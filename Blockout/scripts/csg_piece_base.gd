@tool
class_name CSGPieceBase
extends Node3D


#region /// Exported Variables: Grid

@export var grid_unit: float = 4.0:
	set(value):
		grid_unit = safe_float(value, 0.5)
		if auto_update:
			update_piece()

#endregion


#region /// Exported Variables: Debug

@export_group("Debug")
@export var auto_update: bool = true

#endregion


#region /// Godot Functions

func _ready() -> void:
	if auto_update:
		update_piece()

#endregion


#region /// Virtual Functions

func update_piece() -> void:
	pass

#endregion


#region /// Helper Functions

func unit(value: float) -> float:
	return value * grid_unit


func safe_float(value: float, minimum: float = 0.1) -> float:
	return max(value, minimum)


func safe_int(value: int, minimum: int = 1) -> int:
	return max(value, minimum)


func refresh() -> void:
	update_piece()

#endregion
