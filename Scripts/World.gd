extends Node2D

@onready var town_markers := $MapContainer/TownMarkers

func _ready():
	load_town_markers()

func load_town_markers():
	for child in town_markers.get_children():
		town_markers.remove_child(child)
		child.queue_free()
	var towns = GameWorld.get_all_towns()
	for town_data in towns:
		var marker = create_town_marker(town_data)
		town_markers.add_child(marker)

func create_town_marker(town_data: Dictionary) -> Node2D:
	var marker = Node2D.new()
	marker.name = town_data.get("name", "Unnamed")
	marker.position = town_data.get("map_position", Vector2.ZERO)

	var label = Label.new()
	label.text = town_data.get("name", "Town")
	label.anchor_right = 1
	label.position = Vector2(0, -20)
	marker.add_child(label)

	var area = Area2D.new()
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = 16
	area.add_child(shape)
	marker.add_child(area)

	area.connect("input_event", Callable(self, "_on_town_selected").bind(town_data))
	return marker

func _on_town_selected(viewport, event, shape_idx, town_data):
	if event is InputEventMouseButton and event.pressed:
		print("Selected town: ", town_data.get("name"))
		# You could trigger a scene change here or show town info
