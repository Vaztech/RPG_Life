extends Control

@onready var active_button = $TabContainer/Buttons/ActiveButton
@onready var completed_button = $TabContainer/Buttons/CompletedButton
@onready var quest_list = $TabContainer/QuestList/VBoxContainer
@onready var quest_detail = $TabContainer/QuestDetail/Label
@onready var close_button = $TabContainer/CloseButton

func _ready():
	active_button.connect("pressed", Callable(self, "_on_active_pressed"))
	completed_button.connect("pressed", Callable(self, "_on_completed_pressed"))
	close_button.connect("pressed", Callable(self, "_on_close_pressed"))
	_on_active_pressed()

func _on_active_pressed():
	quest_list.queue_free_children()
	for quest in QuestManager.quests:
		quest_list.add_child(create_quest_entry(quest))

func _on_completed_pressed():
	quest_list.queue_free_children()
	for quest in QuestManager.completed_quests:
		quest_list.add_child(create_quest_entry(quest))

func _on_close_pressed():
	self.visible = false

func create_quest_entry(quest: Dictionary) -> Control:
	var container = HBoxContainer.new()
	var label = Label.new()
	label.text = quest.name
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(label)

	var pin_button = Button.new()
	pin_button.text = "📌" if QuestManager.is_quest_pinned(quest.id) else "📍"
	pin_button.connect("pressed", Callable(self, "_on_pin_pressed").bind(quest.id, pin_button))
	container.add_child(pin_button)

	container.connect("gui_input", Callable(self, "_on_quest_entry_input").bind(quest))
	return container

func _on_quest_entry_input(event: InputEvent, quest: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var details = "Name: %s\n\nDescription:\n%s\n\nObjectives:\n%s" % [
			quest.name,
			quest.description,
			", ".join(quest.objectives)
		]
		quest_detail.text = details

func _on_pin_pressed(quest_id: String, button: Button) -> void:
	if QuestManager.is_quest_pinned(quest_id):
		QuestManager.unpin_quest(quest_id)
		button.text = "📍"
	else:
		QuestManager.pin_quest(quest_id)
		button.text = "📌"
