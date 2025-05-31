extends Node2D

@export var chunk_coords := Vector2i.ZERO

func _ready():
	# Mark this chunk as visited on load
	WorldSaveManager.mark_chunk_modified(chunk_coords, {"visited": true})
