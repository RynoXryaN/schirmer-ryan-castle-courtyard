@tool
class_name CSGCastleWallSection
extends CSGPieceBase


#region /// Exported Variables (Wall)

@export var wall_length: float = 24.0:
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
			
#region /// Exported Variables (Merlon)

@export var merlon_count: int = 8:
	set(value):
		merlon_count = max(value, 0)
		if auto_update:
			update_piece()

@export var merlon_width: float = 1.5:
	set(value):
		merlon_width = safe_float(value)
		if auto_update:
			update_piece()

@export var merlon_height: float = 1.5:
	set(value):
		merlon_height = safe_float(value)
		if auto_update:
			update_piece()

@export var merlon_thickness: float = 1.5:
	set(value):
		merlon_thickness = safe_float(value)
		if auto_update:
			update_piece()
			
#endregion
			
#region /// Exported Variables (WallWalk)
			
@export var wall_walk_depth: float = 2.5:
	set(value):
		wall_walk_depth = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_walk_thickness: float = 0.25:
	set(value):
		wall_walk_thickness = safe_float(value)
		if auto_update:
			update_piece()

@export var wall_walk_z_offset: float = -0.75:
	set(value):
		wall_walk_z_offset = value
		if auto_update:
			update_piece()
			
@export var wall_walk_y_offset: float = -1.0:
	set(value):
		wall_walk_y_offset = value
		if auto_update:
			update_piece()

#endregion

#region /// Other Exported Variables

@export var bottom_at_zero: bool = true:
	set(value):
		bottom_at_zero = value
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	_update_wall()
	_update_wall_walk()
	_update_merlons()

func _update_wall() -> void:
	var wall := get_node_or_null("Wall") as CSGBox3D
	if wall == null:
		return

	wall.size = Vector3(wall_length, wall_height, wall_thickness)

	if bottom_at_zero:
		wall.position.y = wall_height / 2.0
	else:
		wall.position.y = 0.0


func _update_merlons() -> void:
	var merlons := get_node_or_null("Merlons") as Node3D
	if merlons == null:
		return

	for child in merlons.get_children():
		child.queue_free()

	if merlon_count <= 0:
		return

	var spacing := wall_length / float(merlon_count)
	var start_x := -wall_length / 2.0 + spacing / 2.0
	var top_y := wall_height + merlon_height / 2.0

	for i in merlon_count:
		var merlon := CSGBox3D.new()
		merlon.name = "Merlon_%02d" % i
		merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
		merlon.position = Vector3(start_x + spacing * i, top_y, 0.0)
		merlons.add_child(merlon)
		merlon.owner = get_tree().edited_scene_root
		
func _update_wall_walk() -> void:
	var wall_walk := get_node_or_null("WallWalk") as CSGBox3D
	if wall_walk == null:
		return

	wall_walk.size = Vector3(wall_length, wall_walk_thickness, wall_walk_depth)

	var back_of_wall_z := -wall_thickness / 2.0
	var wall_walk_center_z := back_of_wall_z - wall_walk_depth / 2.0

	wall_walk.position = Vector3(
		0.0,
		wall_height - wall_walk_thickness / 2.0 + wall_walk_y_offset,
		wall_walk_center_z
	)

#endregion
