@tool
extends Node3D
class_name SmartBuildPiece


@export_group("Smart Build Piece")
@export var meters_per_unit: float = 4.0

@export var rebuild_now: bool = false:
	set(value):
		rebuild_now = false
		if Engine.is_editor_hint():
			rebuild()

@export var clear_now: bool = false:
	set(value):
		clear_now = false
		if Engine.is_editor_hint():
			clear_generated()


var generated_root: Node3D


func _ready() -> void:
	ensure_generated_root()
	rebuild()


func unit(value: float) -> float:
	return value * meters_per_unit


func ensure_generated_root() -> Node3D:
	if generated_root != null and is_instance_valid(generated_root):
		return generated_root

	generated_root = get_node_or_null("Generated") as Node3D

	if generated_root == null:
		generated_root = Node3D.new()
		generated_root.name = "Generated"
		add_child(generated_root)

		if Engine.is_editor_hint():
			generated_root.owner = get_tree().edited_scene_root

	return generated_root


func clear_generated() -> void:
	var root := ensure_generated_root()

	for child in root.get_children():
		child.queue_free()


func rebuild() -> void:
	# Child scripts override this.
	pass


func set_visible_if_exists(path: NodePath, value: bool) -> void:
	var node := get_node_or_null(path)
	if node:
		node.visible = value


func spawn_scene(
	scene: PackedScene,
	spawn_name: String,
	position: Vector3 = Vector3.ZERO,
	rotation_degrees_y: float = 0.0,
	parent: Node = null
) -> Node3D:
	if scene == null:
		push_warning("Missing PackedScene for: " + spawn_name)
		return null

	var instance := scene.instantiate() as Node3D

	if instance == null:
		push_warning(spawn_name + " is not a Node3D scene.")
		return null

	var target_parent := parent
	if target_parent == null:
		target_parent = ensure_generated_root()

	target_parent.add_child(instance)
	instance.name = spawn_name
	instance.position = position
	instance.rotation_degrees.y = rotation_degrees_y

	#if Engine.is_editor_hint():
		#var scene_root := get_tree().edited_scene_root
		#instance.owner = scene_root
		#_set_owner_recursive(instance, scene_root)

	return instance


func _set_owner_recursive(node: Node, owner_node: Node) -> void:
	node.owner = owner_node

	for child in node.get_children():
		_set_owner_recursive(child, owner_node)
		
		
func _create_static_box(
	box_name: String,
	position: Vector3,
	size: Vector3
) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = box_name
	body.position = position

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"

	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh

	var collision := CollisionShape3D.new()
	collision.name = "Collision"

	var box_shape := BoxShape3D.new()
	box_shape.size = size
	collision.shape = box_shape

	body.add_child(mesh_instance)
	body.add_child(collision)

	var root := ensure_generated_root()
	root.add_child(body)

	#if Engine.is_editor_hint():
		#var scene_root := get_tree().edited_scene_root
		#body.owner = scene_root
		#mesh_instance.owner = scene_root
		#collision.owner = scene_root

	return body
