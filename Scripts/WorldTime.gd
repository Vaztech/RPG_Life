extends Node

var current_day: int = 1
var current_hour: int = 8

signal time_changed(current_day, current_hour)

func advance_time(hours: int = 1) -> void:
	current_hour += hours
	if current_hour >= 24:
		current_hour = current_hour % 24
		current_day += 1
	emit_signal("time_changed", current_day, current_hour)

func _ready() -> void:
	print("WorldTime initialized. Day:", current_day, "Hour:", current_hour)
