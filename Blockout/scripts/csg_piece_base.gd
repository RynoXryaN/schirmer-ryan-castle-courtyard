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

#region /// Exported Variables: Collision

@export var use_generated_collision: bool = true
@export_flags_3d_physics var generated_collision_layer: int = 1
@export_flags_3d_physics var generated_collision_mask: int = 1

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
	
func _set_owner_safe(node: Node) -> void:
	if node == null:
		return

	if Engine.is_editor_hint() and get_tree() != null:
		var scene_root := get_tree().edited_scene_root
		if scene_root != null:
			node.owner = scene_root
			return

	node.owner = owner
	pass
	

func _setup_csg_collision(csg: CSGShape3D) -> void:
	if csg == null:
		return

	csg.use_collision = use_generated_collision
	csg.collision_layer = generated_collision_layer
	csg.collision_mask = generated_collision_mask


#endregion
