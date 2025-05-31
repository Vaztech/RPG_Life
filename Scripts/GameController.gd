extends Node

@onready var player = $Player
@onready var encounter_manager = $EncounterManager

func _process(_delta):
    if Input.is_action_just_pressed("trigger_encounter"): # debug/test key
        encounter_manager.trigger_random_encounter(player)