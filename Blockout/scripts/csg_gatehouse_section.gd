@tool
class_name CSGGatehouseSection
extends CSGPieceBase


#region /// Exported Variables (Gate)

@export var gate_width: float = 8.0:
	set(value):
		gate_width = safe_float(value)
		if auto_update:
			update_piece()

#endregion

#region /// Exported Variables (Tower)

@export var tower_radius: float = 3.5:
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
			
#endregion

#region /// Exported Variables (TopWall)

@export var top_wall_height: float = 2.0:
	set(value):
		top_wall_height = safe_float(value)
		if auto_update:
			update_piece()

@export var top_wall_thickness: float = 1.5:
	set(value):
		top_wall_thickness = safe_float(value)
		if auto_update:
			update_piece()
			
#endregion

#region /// Exported Variables (Merlon)

@export var merlon_count: int = 6:
	set(value):
		merlon_count = max(value, 0)
		if auto_update:
			update_piece()

@export var merlon_width: float = 1.2:
	set(value):
		merlon_width = safe_float(value)
		if auto_update:
			update_piece()

@export var merlon_height: float = 1.4:
	set(value):
		merlon_height = safe_float(value)
		if auto_update:
			update_piece()

@export var merlon_thickness: float = 1.4:
	set(value):
		merlon_thickness = safe_float(value)
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	_update_towers()
	_update_top_wall()
	_update_merlons()


func _update_towers() -> void:
	var left_tower := get_node_or_null("LeftTower") as CSGCylinder3D
	var right_tower := get_node_or_null("RightTower") as CSGCylinder3D

	if left_tower == null or right_tower == null:
		return

	var tower_x := gate_width / 2.0 + tower_radius

	for tower in [left_tower, right_tower]:
		tower.radius = tower_radius
		tower.height = tower_height
		tower.sides = tower_sides
		tower.position.y = tower_height / 2.0

	left_tower.position.x = -tower_x
	right_tower.position.x = tower_x


func _update_top_wall() -> void:
	var top_wall := get_node_or_null("TopWall") as CSGBox3D
	var top_walk := get_node_or_null("TopWalk") as CSGBox3D

	if top_wall == null or top_walk == null:
		return

	var total_width := gate_width + tower_radius * 2.0

	top_wall.size = Vector3(total_width, top_wall_height, top_wall_thickness)
	top_wall.position = Vector3(0.0, tower_height - top_wall_height / 2.0, 0.0)

	top_walk.size = Vector3(total_width, 0.35, top_wall_thickness + 1.0)
	top_walk.position = Vector3(0.0, tower_height - 0.175, -0.5)


func _update_merlons() -> void:
	var merlons := get_node_or_null("Merlons") as Node3D
	if merlons == null:
		return

	for child in merlons.get_children():
		child.free()

	if merlon_count <= 0:
		return

	var total_width := gate_width + tower_radius * 2.0
	var spacing := total_width / float(merlon_count)
	var start_x := -total_width / 2.0 + spacing / 2.0
	var top_y := tower_height + merlon_height / 2.0

	for i in merlon_count:
		var merlon := CSGBox3D.new()
		merlon.name = "Merlon_%02d" % i
		merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
		merlon.position = Vector3(start_x + spacing * i, top_y, 0.0)
		merlons.add_child(merlon)
		merlon.owner = get_tree().edited_scene_root

#endregion
