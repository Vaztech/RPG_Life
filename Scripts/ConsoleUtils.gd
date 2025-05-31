class_name ConsoleUtils
extends Node

# Provides colorized print/input alternatives for debugging and text-based prototypes

enum Color {
    RED,
    YELLOW,
    CYAN,
    WHITE,
    GREEN,
    BLUE
}

func console_print(message: String, color: Color = Color.WHITE) -> void:
    print(message) # You could replace this with RichTextLabel or Console output handling

func console_input(prompt: String, color: Color = Color.WHITE) -> String:
    # In a Godot UI, you'd prompt via UI; this is a stub
    print(prompt)
    return ""