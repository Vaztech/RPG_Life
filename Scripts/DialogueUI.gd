
extends CanvasLayer

@onready var speaker_label = $VBoxContainer/Speaker
@onready var line_label = $VBoxContainer/Line
@onready var continue_button = $VBoxContainer/Continue
@onready var portrait_sprite = $VBoxContainer/Portrait

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	visible = false

func show_line(entry: Dictionary):
	visible = true
	speaker_label.text = entry.get("speaker", "")
	line_label.text = ""
	portrait_sprite.visible = entry.has("portrait")
	if portrait_sprite.visible:
		portrait_sprite.texture = load(entry["portrait"])
	_type_text(entry.get("line", ""))

func _type_text(text: String):
	line_label.text = ""
	var char_index = 0
	var timer = Timer.new()
	timer.wait_time = 0.02
	timer.one_shot = false
	timer.timeout.connect(func():
		if char_index < text.length():
			line_label.text += text[char_index]
			char_index += 1
		else:
			timer.queue_free()
	)
	add_child(timer)
	timer.start()

func _on_continue_pressed():
	DialogueManager.next_line()
