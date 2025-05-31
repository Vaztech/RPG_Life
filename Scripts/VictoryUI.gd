extends CanvasLayer

@onready var continue_button = $Panel/ContinueButton

signal continue_to_world

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)

func _on_continue_pressed():
	self.visible = false
	emit_signal("continue_to_world")
