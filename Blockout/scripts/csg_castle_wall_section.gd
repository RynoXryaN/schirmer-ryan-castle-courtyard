@tool
class_name CSGCastleWallSection
extends CSGPieceBase


#region /// Wall

@export_category("Wall")

@export var length_units: float = 4.0:
	set(value):
		length_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var height_units: float = 1.5:
	set(value):
		height_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

@export var wall_thickness_units: float = 0.25:
	set(value):
		wall_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// WallWalk

@export_category("WallWalk")

@export var wall_walk_width_units: float = 0.75:
	set(value):
		wall_walk_width_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var wall_walk_thickness_units: float = 0.1:
	set(value):
		wall_walk_thickness_units = safe_float(value, 0.025)
		if auto_update:
			update_piece()
			
@export var wall_walk_height_units: float = 1.0:
	set(value):
		wall_walk_height_units = safe_float(value, 0.25)
		if auto_update:
			update_piece()

#endregion


#region /// Parapet

@export_category("Parapet")

@export var parapet_height_units: float = 0.25:
	set(value):
		parapet_height_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var parapet_thickness_units: float = 0.25:
	set(value):
		parapet_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// Merlons

@export_category("Merlons")

@export var merlon_count: int = 6:
	set(value):
		merlon_count = max(value, 0)
		if auto_update:
			update_piece()

@export var merlon_width_units: float = 0.3:
	set(value):
		merlon_width_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var merlon_height_units: float = 0.35:
	set(value):
		merlon_height_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

@export var merlon_thickness_units: float = 0.25:
	set(value):
		merlon_thickness_units = safe_float(value, 0.05)
		if auto_update:
			update_piece()

#endregion


#region /// Update Logic

func update_piece() -> void:
	_update_wall()
	_update_wall_walk()
	
	_update_parapet()
	_update_merlons()
	pass


func _update_wall() -> void:
	var wall := get_node_or_null("Wall") as CSGBox3D
	if wall == null:
		return

	var length := unit(length_units)
	var height := unit(height_units)
	var thickness := unit(wall_thickness_units)

	wall.size = Vector3(length, height, thickness)
	wall.position = Vector3(0.0, height / 2.0, 0.0)
	pass


func _update_wall_walk() -> void:
	var wall_walk := get_node_or_null("WallWalk") as CSGBox3D
	if wall_walk == null:
		return

	var length := unit(length_units)
	var height := unit(height_units)
	var thickness := unit(wall_thickness_units)
	var walk_width := unit(wall_walk_width_units)
	var walk_thickness := unit(wall_walk_thickness_units)
	var walk_height := unit(wall_walk_height_units)
	var walk_z := thickness / 2.0 + walk_width / 2.0
	
	wall_walk.size = Vector3(length, walk_thickness, walk_width)
	wall_walk.position = Vector3(0.0, walk_height - walk_thickness / 2.0, walk_z)
	pass


func _update_parapet() -> void:
	var parapet := get_node_or_null("Parapet") as Node3D
	if parapet == null:
		return

	for child in parapet.get_children():
		child.queue_free()

	var length := unit(length_units)
	var height := unit(height_units)
	var walk_width := unit(wall_walk_width_units)
	var wall_walk_thickness := unit(wall_walk_thickness_units)
	var walk_height := unit(wall_walk_height_units)
	var parapet_height := unit(parapet_height_units)
	var parapet_thickness := unit(parapet_thickness_units)
	var wall_walk_y := height
	var wall_walk_top := wall_walk_y + wall_walk_thickness / 2.0
	var y := height + parapet_height / 2.0
	var front_z := -walk_width / 2.0 + parapet_thickness / 2.0

	_add_box(
		parapet,
		"FrontParapet",
		Vector3(length, parapet_height, parapet_thickness),
		Vector3(0.0, y, front_z)
	)

	pass


func _update_merlons() -> void:
	var merlons := get_node_or_null("Merlons") as Node3D
	if merlons == null:
		return

	for child in merlons.get_children():
		child.queue_free()

	if merlon_count <= 0:
		return

	var length := unit(length_units)
	var height := unit(height_units)
	var walk_width := unit(wall_walk_width_units)
	var wall_walk_thickness := unit(wall_walk_thickness_units)
	var wall_walk_y := height
	var wall_walk_top := wall_walk_y + wall_walk_thickness / 2.0
	var parapet_height := unit(parapet_height_units)

	var merlon_width := unit(merlon_width_units)
	var merlon_height := unit(merlon_height_units)
	var merlon_thickness := unit(merlon_thickness_units)

	var y := height + parapet_height + merlon_height / 2.0
	var z := -walk_width / 2.0 + merlon_thickness / 2.0

	var spacing := length / float(merlon_count)
	var start := -length / 2.0 + spacing / 2.0

	for i in merlon_count:
		var merlon := CSGBox3D.new()
		merlon.name = "Merlon_%02d" % i
		merlon.size = Vector3(merlon_width, merlon_height, merlon_thickness)
		merlon.position = Vector3(start + spacing * i, y, z)

		merlons.add_child(merlon)
		_set_owner_safe(merlon)

	pass


func _add_box(parent: Node3D, box_name: String, box_size: Vector3, box_position: Vector3) -> void:
	if parent == null:
		push_error("_add_box failed: parent is null for " + box_name)
		return

	var box := CSGBox3D.new()
	box.name = box_name
	box.size = box_size
	box.position = box_position

	parent.add_child(box)
	_set_owner_safe(box)
	pass
	
	
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

#endregion
