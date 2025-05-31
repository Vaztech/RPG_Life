
extends Node

class_name WorldEventManager

# Enum for predefined world event states
enum EventState {
    NONE,
    PEACE,
    PLAGUE,
    WAR,
    FAMINE,
    FESTIVAL,
    CURSED_REALM
}

var current_event_state := EventState.NONE
var seed := 0

func _ready():
    randomize()
    seed = randi()
    current_event_state = _choose_initial_event()
    print("World event set to:", get_event_name())

func _choose_initial_event() -> int:
    var options = [EventState.PEACE, EventState.PLAGUE, EventState.WAR, EventState.FAMINE, EventState.FESTIVAL, EventState.CURSED_REALM]
    return options[randi() % options.size()]

func set_event(state: int) -> void:
    current_event_state = state

func get_event() -> int:
    return current_event_state

func get_event_name() -> String:
    return EventState.keys()[current_event_state]

func get_event_tone_modifier() -> String:
    match current_event_state:
        EventState.PEACE:
            return "hopeful"
        EventState.PLAGUE:
            return "grim"
        EventState.WAR:
            return "defiant"
        EventState.FAMINE:
            return "desperate"
        EventState.FESTIVAL:
            return "joyous"
        EventState.CURSED_REALM:
            return "ominous"
        _:
            return "neutral"
