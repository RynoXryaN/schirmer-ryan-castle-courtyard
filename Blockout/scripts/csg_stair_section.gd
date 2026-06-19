@tool
class_name CSGStairSection
extends CSGPieceBase


#region /// Exported Variables

@export var height_sections: int = 4:
	set(value):
		height_sections = max(value, 1)
		if auto_update:
			update_piece()

@export var rise_per_section: float = 2.0:
	set(value):
		rise_per_section = safe_float(value)
		if auto_update:
			update_piece()

@export var run_per_section: float = 3.0:
	set(value):
		run_per_section = safe_float(value)
		if auto_update:
			update_piece()

@export var steps_per_section: int = 4:
	set(value):
		steps_per_section = max(value, 1)
		if auto_update:
			update_piece()

@export var stair_width: float = 3.0:
	set(value):
		stair_width = safe_float(value)
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	var steps := get_node_or_null("Steps") as Node3D
	if steps == null:
		return

	for child in steps.get_children():
		child.free()

	var total_steps := height_sections * steps_per_section
	var step_height := rise_per_section / float(steps_per_section)
	var step_depth := run_per_section / float(steps_per_section)

	for i in total_steps:
		var step := CSGBox3D.new()
		step.name = "Step_%02d" % i

		var current_height := step_height * float(i + 1)

		step.size = Vector3(stair_width, current_height, step_depth)

		step.position = Vector3(
			0.0,
			current_height / 2.0,
			float(i) * step_depth + step_depth / 2
		)

		steps.add_child(step)
		step.owner = get_tree().edited_scene_root

#endregion
