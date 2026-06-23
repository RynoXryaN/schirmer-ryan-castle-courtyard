@tool
extends Resource
class_name TowerFloorOpenings


enum OpeningType {
	WALL,
	WINDOW,
	DOOR
}


@export_group("Floor Side Openings")
@export_enum("Wall", "Window", "Door")
var north: int = OpeningType.WALL:
	set(value):
		north = value
		emit_changed()

@export_enum("Wall", "Window", "Door")
var south: int = OpeningType.WALL:
	set(value):
		south = value
		emit_changed()

@export_enum("Wall", "Window", "Door")
var east: int = OpeningType.WALL:
	set(value):
		east = value
		emit_changed()

@export_enum("Wall", "Window", "Door")
var west: int = OpeningType.WALL:
	set(value):
		west = value
		emit_changed()
