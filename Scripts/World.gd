extends Node2D
# World (Node2D)
# ├─ MapTileMap      : TileMapLayer
# └─ MapContainer    : Node/Node2D
#    └─ TownMarkers  : Node/Node2D

@onready var tile_layer: TileMapLayer = $MapTileMap
@onready var town_markers: Node       = $MapContainer/TownMarkers

@export var default_map_size: Vector2i = Vector2i(64, 64)  # quick visual fill

var did_generate: bool = false

func _enter_tree() -> void:
	add_to_group("world_root")

func _ready() -> void:
	print("[World] ready at:", get_path())
	if not is_instance_valid(tile_layer):
		push_warning("MapTileMap (TileMapLayer) not found. Terrain painting will be skipped.")
	if not is_instance_valid(town_markers):
		push_warning("TownMarkers node not found. Town markers will not appear.")
	load_town_markers()

func generate_from_seed(seed_value: int) -> void:
	if did_generate:
		push_warning("generate_from_seed called again; ignoring.")
		return
	did_generate = true
	print("[World] generate_from_seed ->", seed_value)

	_debug_fill_tiles()
	load_town_markers()

# --- Helpers ----------------------------------------------------------------

func _debug_fill_tiles() -> void:
	if not is_instance_valid(tile_layer):
		return

	var tileset: TileSet = tile_layer.tile_set
	if tileset == null or tileset.get_source_count() == 0:
		push_warning("TileSet is missing or has no Atlas Sources. Add one in the TileSet dock.")
		return

	# Use the first listed source (whatever its actual ID is).
	var source_id: int = tileset.get_source_id(0)
	var source: TileSetSource = tileset.get_source(source_id)

	var atlas_xy: Vector2i = Vector2i.ZERO
	var atlas_ok: bool = false

	if source is TileSetAtlasSource:
		var atlas_source: TileSetAtlasSource = source
		var count: int = atlas_source.get_tiles_count()
		if count > 0:
			atlas_xy = atlas_source.get_tile_id(0)  # <- Godot 4 API: get_tile_id(index) -> Vector2i
			atlas_ok = true
	else:
		push_warning("First TileSet source is not an Atlas source; add an AtlasSource with your tilesheet.")
		return

	if not atlas_ok:
		push_warning("Could not find a valid atlas tile in the first TileSet source.")
		return

	tile_layer.clear()
	var size: Vector2i = default_map_size
	for x in range(size.x):
		for y in range(size.y):
			tile_layer.set_cell(Vector2i(x, y), source_id, atlas_xy)

func load_town_markers() -> void:
	if not is_instance_valid(town_markers):
		return

	for c in town_markers.get_children():
		c.queue_free()

	var towns: Array = []
	var parent_world: Node = get_parent()
	if parent_world and parent_world.has_method("get_all_towns"):
		towns = parent_world.get_all_towns()
	else:
		towns = [
			{"name": "Oakford",  "position": Vector2i(8, 8)  * 16},
			{"name": "Rimehold", "position": Vector2i(24,12) * 16},
		]

	for town_data in towns:
		var marker: Node2D = _create_town_marker(town_data)
		town_markers.add_child(marker)

func _create_town_marker(town_data: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = str(town_data.get("name", "Town"))
	marker.position = Vector2(town_data.get("position", Vector2i.ZERO))

	var dot := ColorRect.new()
	dot.color = Color(0.85, 0.2, 0.2, 0.95)
	dot.size = Vector2(12, 12)
	dot.position = Vector2(-6, -6)
	marker.add_child(dot)

	var label := Label.new()
	label.text = marker.name
	label.position = Vector2(10, -6)
	marker.add_child(label)

	var area := Area2D.new()
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 10.0
	shape.shape = circle
	area.add_child(shape)
	marker.add_child(area)

	area.connect("input_event", Callable(self, "_on_town_selected").bind(town_data))
	return marker

func _on_town_selected(_viewport: Viewport, event: InputEvent, _shape_idx: int, town_data: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Selected town:", town_data.get("name"))
