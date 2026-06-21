@tool
class_name CSGStairSection
extends CSGPieceBase


#region /// Exported Variables: Stairs

@export var height_sections: int = 2:
	set(value):
		height_sections = safe_int(value)
		if auto_update:
			update_piece()

@export var rise_units_per_section: float = 0.5:
	set(value):
		rise_units_per_section = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var run_units_per_section: float = 0.75:
	set(value):
		run_units_per_section = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var steps_per_section: int = 4:
	set(value):
		steps_per_section = safe_int(value)
		if auto_update:
			update_piece()

@export var stair_width_units: float = 1.0:
	set(value):
		stair_width_units = safe_float(value, 0.25)
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
	var step_height := unit(rise_units_per_section) / float(steps_per_section)
	var step_depth := unit(run_units_per_section) / float(steps_per_section)
	var stair_width := unit(stair_width_units)

	for i in total_steps:
		var step := CSGBox3D.new()
		step.name = "Step_%02d" % i

		var current_height := step_height * float(i + 1)

		step.size = Vector3(stair_width, current_height, step_depth)

		step.position = Vector3(
			0.0,
			current_height / 2.0,
			float(i) * step_depth + step_depth / 2.0
		)

		steps.add_child(step)
		step.owner = get_tree().edited_scene_root

#endregion
