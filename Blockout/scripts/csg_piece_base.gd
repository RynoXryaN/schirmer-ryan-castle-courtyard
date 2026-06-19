@tool
class_name CSGPieceBase
extends Node3D


#region Exported Variables

@export_group("Debug")
@export var auto_update := true

#endregion


#region Godot Functions

func _ready() -> void:
	if auto_update:
		update_piece()

#endregion


#region /// Virtual Functions

func get_piece_node() -> Node:
	return null

func update_piece() -> void:
	pass

#endregion


#region Helper Functions

func safe_float(value: float, minimum: float = 0.1) -> float:
	return max(value, minimum)

func refresh() -> void:
	update_piece()

#endregion
