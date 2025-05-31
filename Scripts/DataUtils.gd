class_name DataUtils
extends Node

static func ensure_data_dir() -> String:
    var data_path = "user://data/"
    var dir = DirAccess.open(data_path)
    if not dir:
        DirAccess.make_dir_recursive_absolute(data_path)
    return data_path