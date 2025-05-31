class_name Room
extends Resource

@export var name: String
@export var description: String
@export var terrain_type: String = "Plain"
@export var is_blocking: bool = false
@export var has_event: bool = false
@export var exits: Dictionary = {}  # {"north": "room_id"}

func _init(_name := "", _desc := "", _terrain := "Plain", _blocking := false, _event := false):
    name = _name
    description = _desc
    terrain_type = _terrain
    is_blocking = _blocking
    has_event = _event
    exits = {}