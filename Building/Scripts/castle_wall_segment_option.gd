@tool
extends Resource
class_name CastleWallSegmentOption


enum SegmentType {
	WALL,
	WINDOW,
	DOOR
}


@export_enum("Wall", "Window", "Door")
var segment_type: int = SegmentType.WALL:
	set(value):
		segment_type = value
		emit_changed()
