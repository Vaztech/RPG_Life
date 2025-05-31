class_name InputHandler
extends Node

signal command_received(command: String)

func _input(event):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_W:
                emit_signal("command_received", "north")
            KEY_S:
                emit_signal("command_received", "south")
            KEY_A:
                emit_signal("command_received", "west")
            KEY_D:
                emit_signal("command_received", "east")