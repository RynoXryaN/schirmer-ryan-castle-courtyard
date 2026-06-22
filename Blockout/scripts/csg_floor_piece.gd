@tool
class_name CSGFloorPiece
extends CSGPieceBase


#region /// Exported Variables: Floor

@export var floor_width_units: int = 15:
	set(value):
		floor_width_units = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_depth_units: int = 20:
	set(value):
		floor_depth_units = safe_int(value)
		if auto_update:
			update_piece()

@export var floor_thickness_units: float = 0.125:
	set(value):
		floor_thickness_units = safe_float(value, 0.025)
		if auto_update:
			update_piece()

@export var top_surface_at_zero: bool = true:
	set(value):
		top_surface_at_zero = value
		if auto_update:
			update_piece()

#endregion

#region /// Perimeter Barrier

@export_group("Invisible Perimeter Collision")
@export var generate_perimeter_collision: bool = true:
	set(value):
		generate_perimeter_collision = value
		update_piece()

@export var perimeter_height_units: float = 2.0:
	set(value):
		perimeter_height_units = value
		update_piece()

@export var perimeter_thickness_units: float = 0.25:
	set(value):
		perimeter_thickness_units = value
		update_piece()

#endregion

#region /// Update Logic

func update_piece() -> void:
	var floor := get_node_or_null("Floor") as CSGBox3D
	if floor == null:
		return

	var floor_width := unit(floor_width_units)
	var floor_depth := unit(floor_depth_units)
	var floor_thickness := unit(floor_thickness_units)

	floor.size = Vector3(floor_width, floor_thickness, floor_depth)

	if top_surface_at_zero:
		floor.position.y = -floor_thickness / 2.0
	else:
		floor.position.y = floor_thickness / 2.0
		
	_update_perimeter_collision()
	pass

#endregion

func _update_perimeter_collision() -> void:
	var barriers := get_node_or_null("InvisiblePerimeterCollision") as Node3D

	if barriers == null:
		barriers = Node3D.new()
		barriers.name = "InvisiblePerimeterCollision"
		add_child(barriers)
		_set_owner_safe(barriers)

	for child in barriers.get_children():
		child.free()

	if not generate_perimeter_collision:
		return

	var floor_width := unit(floor_width_units)
	var floor_depth := unit(floor_depth_units)
	var barrier_height := unit(perimeter_height_units)
	var barrier_thickness := unit(perimeter_thickness_units)

	var y := barrier_height / 2.0

	_add_invisible_collision_box(
		barriers,
		"NorthBarrier",
		Vector3(floor_width + barrier_thickness * 2.0, barrier_height, barrier_thickness),
		Vector3(0.0, y, -floor_depth / 2.0 - barrier_thickness / 2.0)
	)

	_add_invisible_collision_box(
		barriers,
		"SouthBarrier",
		Vector3(floor_width + barrier_thickness * 2.0, barrier_height, barrier_thickness),
		Vector3(0.0, y, floor_depth / 2.0 + barrier_thickness / 2.0)
	)

	_add_invisible_collision_box(
		barriers,
		"EastBarrier",
		Vector3(barrier_thickness, barrier_height, floor_depth),
		Vector3(floor_width / 2.0 + barrier_thickness / 2.0, y, 0.0)
	)

	_add_invisible_collision_box(
		barriers,
		"WestBarrier",
		Vector3(barrier_thickness, barrier_height, floor_depth),
		Vector3(-floor_width / 2.0 - barrier_thickness / 2.0, y, 0.0)
	)
	pass
	
	
func _add_invisible_collision_box(parent: Node3D, box_name: String, box_size: Vector3, box_position: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = box_name
	body.position = box_position
	body.collision_layer = 1
	body.collision_mask = 1

	var shape := CollisionShape3D.new()
	shape.name = "CollisionShape3D"

	var box_shape := BoxShape3D.new()
	box_shape.size = box_size
	shape.shape = box_shape

	body.add_child(shape)
	parent.add_child(body)

	_set_owner_safe(body)
	_set_owner_safe(shape)
	pass
