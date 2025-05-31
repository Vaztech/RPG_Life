class_name TimelineManager
extends Node

func add_event(event_name: String, year: int) -> void:
    var db := get_node("/root/Main/DatabaseManager")
    if not db:
        push_error("DatabaseManager not found")
        return
    var query := "INSERT INTO events (name, description) VALUES ('%s', 'Event in year %d')" % [event_name, year]
    db.query(query)