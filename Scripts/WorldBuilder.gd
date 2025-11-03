extends Control
# Robust WorldBuilder: auto-finds/wires controls, safe seed parsing,
# auto-populates World Type options if empty, and guards selection.

@export var seed_field_path: NodePath
@export var width_spin_path: NodePath
@export var height_spin_path: NodePath
@export var world_type_path: NodePath
@export var back_button_path: NodePath
@export var continue_button_path: NodePath

var seed_field: LineEdit
var width_spin: SpinBox
var height_spin: SpinBox
var world_type: OptionButton
var back_btn: Button
var cont_btn: Button

func _ready() -> void:
	# Resolve explicit paths
	seed_field  = get_node_or_null(seed_field_path)
	width_spin  = get_node_or_null(width_spin_path)
	height_spin = get_node_or_null(height_spin_path)
	back_btn    = get_node_or_null(back_button_path)
	cont_btn    = get_node_or_null(continue_button_path)

	# world_type must be an OptionButton; warn if the path points to a container by mistake
	var n := get_node_or_null(world_type_path)
	if n is OptionButton:
		world_type = n
	elif n != null:
		push_warning("world_type_path must point to an OptionButton, got %s" % [n.get_class()])

	# Fallback auto-discovery (optional)
	if seed_field == null:  seed_field  = _find_first_line_edit(self)
	if width_spin == null:  width_spin  = _find_spin_by_neighbor_label(self, ["Width"])
	if height_spin == null: height_spin = _find_spin_by_neighbor_label(self, ["Height"])
	if world_type == null:  world_type  = _find_option_by_neighbor_label(self, ["World Type","World type"])
	if back_btn == null:    back_btn    = _find_button_with_text(self, ["Back"])
	if cont_btn == null:    cont_btn    = _find_button_with_text(self, ["Continue","Next","Start"])

	# Seed UX
	if seed_field:
		seed_field.placeholder_text = "Enter seed (digits = exact; text = hashed)"
		seed_field.tooltip_text = "Digits use the number directly; text is hashed to a stable seed."

	# Populate defaults for world type if empty
	if world_type:
		if world_type.item_count == 0:
			for label in ["Default", "Islands", "Desert", "Snow", "Mountains"]:
				world_type.add_item(label)
		if world_type.selected < 0 and world_type.item_count > 0:
			world_type.select(0)

	# Reasonable defaults for size
	if width_spin and width_spin.value <= 0:  width_spin.value = 128
	if height_spin and height_spin.value <= 0: height_spin.value = 128

	# Wire buttons
	if back_btn:  back_btn.pressed.connect(_go_back)
	if cont_btn:  cont_btn.pressed.connect(_continue)
	else: push_warning("WorldBuilder: Continue button not found—assign continue_button_path or name it 'Continue'.")

func _go_back() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _continue() -> void:
	if not width_spin or not height_spin:
		push_warning("WorldBuilder: required controls not assigned; cannot continue.")
		return

	var seed_text: String = seed_field.text.strip_edges() if seed_field else ""
	var seed_value: int = _parse_seed(seed_text)

	var w: int = int(width_spin.value)
	var h: int = int(height_spin.value)
	var world_size: Vector2i = Vector2i(max(1, w), max(1, h))

	var world_type_name: String = "Default"
	if world_type and world_type.item_count > 0:
		var idx := world_type.selected
		if idx < 0: idx = 0
		world_type_name = world_type.get_item_text(idx)

	GameConfig.set_world_option("seed", seed_value)
	GameConfig.set_world_option("size", world_size)
	GameConfig.set_world_option("world_type", world_type_name)

	var errs: Array = GameConfig.validate()
	if errs.size() > 0:
		push_warning("World options warnings: %s" % [errs])
		# return  # uncomment to block on validation errors

	print("[WorldBuilder] → CharacterBuilder (seed=%d size=%s type=%s)" %
		[seed_value, str(world_size), world_type_name])
	get_tree().change_scene_to_file("res://Scenes/CharacterBuilder.tscn")

# -------- helpers --------

func _parse_seed(txt: String) -> int:
	if txt.is_empty(): return randi()
	if txt.is_valid_int(): return int(txt)
	var h: int = txt.hash()
	return h & 0x7FFFFFFF

func _find_button_with_text(root: Node, labels: Array[String]) -> Button:
	for child in root.get_children():
		if child is Button:
			var t := (child as Button).text.strip_edges()
			for L in labels:
				if t == L: return child
		var found := _find_button_with_text(child, labels)
		if found: return found
	return null

func _find_first_line_edit(root: Node) -> LineEdit:
	for child in root.get_children():
		if child is LineEdit: return child
		var le := _find_first_line_edit(child)
		if le: return le
	return null

func _find_spin_by_neighbor_label(root: Node, labels: Array[String]) -> SpinBox:
	for child in root.get_children():
		if child is HBoxContainer or child is VBoxContainer:
			var found_label := false
			var spin: SpinBox = null
			for grand in child.get_children():
				if grand is Label:
					var t := (grand as Label).text.strip_edges()
					for L in labels:
						if t == L: found_label = true
				if grand is SpinBox: spin = grand
			if found_label and spin: return spin
		var rec := _find_spin_by_neighbor_label(child, labels)
		if rec: return rec
	return null

func _find_option_by_neighbor_label(root: Node, labels: Array[String]) -> OptionButton:
	for child in root.get_children():
		if child is HBoxContainer or child is VBoxContainer:
			var found_label := false
			var opt: OptionButton = null
			for grand in child.get_children():
				if grand is Label:
					var t := (grand as Label).text.strip_edges()
					for L in labels:
						if t == L: found_label = true
				if grand is OptionButton: opt = grand
			if found_label and opt: return opt
		var rec := _find_option_by_neighbor_label(child, labels)
		if rec: return rec
	return null
