extends CanvasLayer

@onready var label = $Label

func _ready():
	label.text = "Seed: " + str(WorldSeedManager.get_seed())
