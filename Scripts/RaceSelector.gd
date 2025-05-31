class_name RaceSelector
extends Node

func select_race(races: Array) -> String:
    # Replace with UI input in real game
    return races[0].name if races.size() > 0 else "Human"

func select_subrace(subrace_names: Array, race_name: String) -> String:
    return subrace_names[0] if subrace_names.size() > 0 else ""