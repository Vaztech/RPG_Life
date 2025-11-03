extends Control
# Minimal, safe character builder that won't trip the parser

@export var name_field_path: NodePath
@export var class_dd_path: NodePath
@export var back_button_path: NodePath
@export var start_button_path: NodePath

var name_field: LineEdit
var class_dd: OptionButton
var back_btn: Button
var start_btn: Button

# declare temps at class scope to avoid "var" inside functions
var temp_name_text: String = ""
var temp_class_name: String = "Warrior"
var temp_idx: int = 0

func _ready() -> void:
	# Resolve by NodePath
	name_field = get_node_or_null(name_field_path)
	class_dd   = get_node_or_null(class_dd_path)
	back_btn   = get_node_or_null(back_button_path)
	start_btn  = get_node_or_null(start_button_path)

	# Fallback discovery (optional)
	if name_field == null: name_field = _find_first_line_edit(self)
	if class_dd == null:   class_dd   = _find_first_option_button(self)
	if back_btn == null:   back_btn   = _find_button_with_text(self, ["Back"])
	if start_btn == null:  start_btn  = _find_button_with_text(self, ["Start Game","Start","Continue"])

	# Populate class options if empty
	if class_dd:
		if class_dd.item_count == 0:
			_add_class_defaults()
		if class_dd.selected < 0 and class_dd.item_count > 0:
			class_dd.select(0)

	# Wire buttons
	if back_btn:  back_btn.pressed.connect(_go_back)
	if start_btn: start_btn.pressed.connect(_start_game)

func _go_back() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldBuilder.tscn")

func _start_game() -> void:
	if class_dd == null:
		push_warning("CharacterBuilder: class dropdown not found.")
		return

	# name
	temp_name_text = ""
	if name_field:
		temp_name_text = name_field.text.strip_edges()
	if temp_name_text.is_empty():
		temp_name_text = "Adventurer"

	# class
	temp_class_name = "Warrior"
	if class_dd.item_count > 0:
		temp_idx = class_dd.selected
		if temp_idx < 0:
			temp_idx = 0
		temp_class_name = class_dd.get_item_text(temp_idx)

	# save to config
	GameConfig.set_character_option("name", temp_name_text)
	GameConfig.set_character_option("class_name", temp_class_name)

	var errs: Array = GameConfig.validate()
	if errs.size() > 0:
		push_warning("Character options warnings: %s" % [errs])

	# go to game
	get_tree().change_scene_to_file("res://Scenes/GameWorld.tscn")

# ---------- helpers ----------
func _add_class_defaults() -> void:
	# no :=, no type inference warnings
	var defaults = ["Warrior","Ranger","Mage","Cleric","Rogue"]
	var i = 0
	while i < defaults.size():
		class_dd.add_item(defaults[i])
		i += 1

func _find_button_with_text(root: Node, labels: Array[String]) -> Button:
	for child in root.get_children():
		if child is Button:
			var t = (child as Button).text.strip_edges()
			var j = 0
			while j < labels.size():
				if t == labels[j]:
					return child
				j += 1
		var found = _find_button_with_text(child, labels)
		if found: return found
	return null

func _find_first_line_edit(root: Node) -> LineEdit:
	for child in root.get_children():
		if child is LineEdit: return child
		var le = _find_first_line_edit(child)
		if le: return le
	return null

func _find_first_option_button(root: Node) -> OptionButton:
	for child in root.get_children():
		if child is OptionButton: return child
		var ob = _find_first_option_button(child)
		if ob: return ob
	return null
