extends Node2D
# Scene layout:
# World (this)
# ├─ MapTileMap      : TileMapLayer
# └─ MapContainer    : Node/Node2D
#    └─ TownMarkers  : Node

@onready var tile_layer: TileMapLayer = $MapTileMap
@onready var town_markers: Node       = $MapContainer/TownMarkers

var did_generate: bool = false

func _enter_tree() -> void:
	# Register early so GameStarter can find this via the "world_root" group
	add_to_group("world_root")

func _ready() -> void:
	print("[World] ready at:", get_path())
	if not is_instance_valid(tile_layer):
		push_warning("MapTileMap (TileMapLayer) not found. Terrain painting will be skipped.")
	if not is_instance_valid(town_markers):
		push_warning("TownMarkers node not found. Town markers will not appear.")
	load_town_markers()

# Called once by GameStarter.gd after the seed is chosen
func generate_from_seed(seed_value: int) -> void:
	if did_generate:
		push_warning("generate_from_seed called again; ignoring")
		return
	did_generate = true
	print("[World] generate_from_seed ->", seed_value)

	# --- TODO: your terrain generation here ---
	# Example stub for TileMapLayer (leave commented until your sources exist):
	# if is_instance_valid(tile_layer):
	# 	tile_layer.clear()
	# 	var size: Vector2i = Vector2i(128, 128)  # or read from GameConfig
	# 	var source_id: int = 0                   # a valid Tileset source id
	# 	var atlas_coords := Vector2i(0, 0)       # a valid atlas coord in that source
	# 	for x in range(size.x):
	# 		for y in range(size.y):
	# 			tile_layer.set_cell(Vector2i(x, y), source_id, atlas_coords)

	load_town_markers()

func load_town_markers() -> void:
	if not is_instance_valid(town_markers):
		return

	# Clear previous markers
	for c in town_markers.get_children():
		c.queue_free()

	# Ask our *parent GameWorld instance* for towns
	var towns: Array = []
	var parent_world := get_parent()
	if parent_world and parent_world.has_method("get_all_towns"):
		towns = parent_world.get_all_towns()

	for town_data in towns:
		var marker := _create_town_marker(town_data)
		town_markers.add_child(marker)

func _create_town_marker(town_data: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = str(town_data.get("name", "Town"))
	marker.position = Vector2(town_data.get("position", Vector2i.ZERO))

	# Visual dot
	var dot := ColorRect.new()
	dot.color = Color(0.85, 0.2, 0.2, 0.95)
	dot.size = Vector2(12, 12)
	dot.position = Vector2(-6, -6)
	marker.add_child(dot)

	# Label
	var label := Label.new()
	label.text = marker.name
	label.position = Vector2(10, -6)
	marker.add_child(label)

	# Clickable area
	var area := Area2D.new()
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 10.0
	shape.shape = circle
	area.add_child(shape)
	marker.add_child(area)

	# Bind town data to the click handler
	area.connect("input_event", Callable(self, "_on_town_selected").bind(town_data))
	return marker

# Underscore unused params to silence warnings
func _on_town_selected(_viewport: Viewport, event: InputEvent, _shape_idx: int, town_data: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Selected town:", town_data.get("name"))
		# TODO: open town UI / travel / quests, etc.
