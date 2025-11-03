extends Node2D
# Scene shape (expected):
# World (Node2D)
# ├─ MapTileMap      : TileMapLayer           <-- painted by this script
# └─ MapContainer    : Node/Node2D
#    └─ TownMarkers  : Node/Node2D            <-- simple demo markers

# --- Node references ----------------------------------------------------------
@onready var tile_layer: TileMapLayer = $MapTileMap                 # change path if needed
@onready var town_markers: Node       = $MapContainer/TownMarkers   # change path if needed

# --- Defaults / knobs ---------------------------------------------------------
@export var default_map_size: Vector2i = Vector2i(64, 64)  # used if GameConfig has no size
var did_generate: bool = false                              # prevents double generation

# --- Lifecycle / discovery ----------------------------------------------------
func _enter_tree() -> void:
	# Put this World node in a well-known group so GameStarter can find it reliably.
	add_to_group("world_root")

func _ready() -> void:
	# Basic sanity logging and non-fatal warnings if children are missing.
	print("[World] ready at:", get_path())
	if not is_instance_valid(tile_layer):
		push_warning("World: MapTileMap (TileMapLayer) not found; terrain painting will be skipped.")
	if not is_instance_valid(town_markers):
		push_warning("World: TownMarkers node not found; markers will not appear.")
	# Optional: load any pre-existing markers (will be replaced on generation).
	load_town_markers()

# --- Entry point called by GameStarter after it resolves the seed ------------
func generate_from_seed(seed_value: int) -> void:
	# Guard: ignore accidental second calls.
	if did_generate:
		push_warning("World.generate_from_seed called again; ignoring.")
		return
	did_generate = true

	print("[World] generate_from_seed ->", seed_value)

	# Pull world size from GameConfig if available; otherwise use default.
	var cfg_size: Variant = GameConfig.get_world_option("size", default_map_size)
	var map_size: Vector2i = cfg_size if typeof(cfg_size) == TYPE_VECTOR2I else default_map_size
	if map_size.x <= 0 or map_size.y <= 0:
		map_size = default_map_size

	# Paint terrain using *many* different atlas tiles, seeded for determinism.
	_fill_tiles_varied(seed_value, map_size)

	# Drop a couple of demo markers (replace with your real town generation).
	load_town_markers()

# =============================================================================
# Terrain painting (seeded, uses *all* available tiles from first atlas source)
# =============================================================================
func _fill_tiles_varied(seed_value: int, map_size: Vector2i) -> void:
	# Abort early if the TileMapLayer or its TileSet is missing.
	if not is_instance_valid(tile_layer):
		push_warning("World._fill_tiles_varied: tile_layer is null; cannot paint.")
		return
	var tileset: TileSet = tile_layer.tile_set
	if tileset == null or tileset.get_source_count() == 0:
		push_warning("World: TileSet missing or empty; add an Atlas Source in the TileSet dock.")
		return

	# We take the *first* TileSet source (ID is arbitrary) and require that it is an atlas.
	var source_id: int = tileset.get_source_id(0)
	var source: TileSetSource = tileset.get_source(source_id)
	if source == null or not (source is TileSetAtlasSource):
		push_warning("World: first TileSet source is not a TileSetAtlasSource (or null).")
		return
	var atlas: TileSetAtlasSource = source

	# Collect every valid atlas coordinate from the atlas.
	# This is more robust than scanning the grid because it uses the engine’s own index list.
	var coords: Array[Vector2i] = _collect_atlas_coords(atlas)
	if coords.is_empty():
		push_warning("World: no valid atlas tiles found in first TileSet source.")
		return

	# Seeded RNG => same seed + same tileset => identical layout across runs.
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	# Clear and paint a simple rectangle of size map_size.
	tile_layer.clear()
	for y in range(map_size.y):
		for x in range(map_size.x):
			var ac: Vector2i = coords[rng.randi_range(0, coords.size() - 1)]
			# set_cell(cell_coords, source_id, atlas_coords, alternative_tile := 0)
			tile_layer.set_cell(Vector2i(x, y), source_id, ac, 0)

# Helper: return all atlas tile coordinates that actually exist in the atlas.
func _collect_atlas_coords(atlas: TileSetAtlasSource) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var count: int = atlas.get_tiles_count()             # number of tiles defined in atlas
	for i in range(count):
		# Godot 4 API: get_tile_id(index: int) -> Vector2i (atlas coordinate)
		var ac: Vector2i = atlas.get_tile_id(i)
		out.append(ac)
	return out

# =============================================================================
# Demo Town Markers (replace with your procedural town generation)
# =============================================================================
func load_town_markers() -> void:
	if not is_instance_valid(town_markers):
		return

	# Wipe any previous markers.
	for c in town_markers.get_children():
		c.queue_free()

	# Ask parent (e.g., a World/Map controller) for towns if it provides them.
	# Otherwise, use two example entries.
	var towns: Array = []
	var parent_world: Node = get_parent()
	if parent_world and parent_world.has_method("get_all_towns"):
		towns = parent_world.get_all_towns()
	else:
		towns = [
			{"name": "Oakford",  "position": Vector2i(8, 8)  * 16},
			{"name": "Rimehold", "position": Vector2i(24,12) * 16},
		]

	# Create simple visual markers (red dot + label + clickable area).
	for town_data in towns:
		var marker: Node2D = _create_town_marker(town_data)
		town_markers.add_child(marker)

# Build a small clickable town marker from a data dictionary.
func _create_town_marker(town_data: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = str(town_data.get("name", "Town"))
	marker.position = Vector2(town_data.get("position", Vector2i.ZERO))

	# Visual red dot
	var dot := ColorRect.new()
	dot.color = Color(0.85, 0.2, 0.2, 0.95)
	dot.size = Vector2(12, 12)
	dot.position = Vector2(-6, -6)
	marker.add_child(dot)

	# Text label
	var label := Label.new()
	label.text = marker.name
	label.position = Vector2(10, -6)
	marker.add_child(label)

	# Clickable area (small circle)
	var area := Area2D.new()
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 10.0
	shape.shape = circle
	area.add_child(shape)
	marker.add_child(area)

	# When clicked, call _on_town_selected with the original dictionary bound in.
	area.input_event.connect(_on_town_selected.bind(town_data))
	return marker

# Handle clicks on a town marker (left mouse).
func _on_town_selected(_viewport: Viewport, event: InputEvent, _shape_idx: int, town_data: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Selected town:", town_data.get("name"))
