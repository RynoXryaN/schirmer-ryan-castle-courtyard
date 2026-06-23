@tool
extends Node3D
class_name AssetConstructionMachine


#region /// Exported Variables: Units

@export_group("Unit Settings")
@export var meters_per_unit: float = 4.0


func unit(value: float) -> float:
	return value * meters_per_unit

#endregion

#region /// Exported Variables: Build Controls

@export_group("Build Controls")
@export var rebuild_now: bool = false:
	set(value):
		rebuild_now = false
		if Engine.is_editor_hint():
			rebuild()

@export var clear_now: bool = false:
	set(value):
		clear_now = false
		if Engine.is_editor_hint():
			clear_build()

#endregion

#region /// Exported Variables: Scene References
@export_group("Asset Scenes")
@export var wall_scene: PackedScene
@export var floor_scene: PackedScene
@export var tower_scene: PackedScene
@export var gatehouse_scene: PackedScene
@export var stairs_scene: PackedScene

#endregion

#region /// Exported Variables: Build Settings
@export_group("Basic Layout")
@export var floor_width_units: float = 15.0
@export var floor_depth_units: float = 20.0

#endregion
# ------------------------------------------------------------
# Internal
# ------------------------------------------------------------

var build_root: Node3D


func _ready() -> void:
	ensure_build_root()


func ensure_build_root() -> Node3D:
	if build_root != null and is_instance_valid(build_root):
		return build_root

	build_root = get_node_or_null("GeneratedBuild") as Node3D

	if build_root == null:
		build_root = Node3D.new()
		build_root.name = "GeneratedBuild"
		add_child(build_root)
		build_root.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else self

	return build_root


func clear_build() -> void:
	var root := ensure_build_root()

	for child in root.get_children():
		child.queue_free()


func rebuild() -> void:
	clear_build()
	await get_tree().process_frame

	ensure_build_root()
	build()


func build() -> void:
	# This is intentionally empty for now.
	# We will fill this with floor/wall/tower placement next.
	print("Construction machine build() ran.")
