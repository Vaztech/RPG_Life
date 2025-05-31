extends Node

var current_theme := "default"
var tileset_name := "tileset_default.tres"
var palette := Color.WHITE

var THEME_TABLE = {
	"default": {
		"tileset": "tileset_default.tres",
		"color": Color.WHITE
	},
	"bloodmoon": {
		"tileset": "tileset_blood.tres",
		"color": Color(1, 0.25, 0.25)
	},
	"frostvale": {
		"tileset": "tileset_frost.tres",
		"color": Color(0.8, 0.9, 1)
	},
	"swamplands": {
		"tileset": "tileset_swamp.tres",
		"color": Color(0.6, 0.8, 0.6)
	},
	"ashendusk": {
		"tileset": "tileset_ashen.tres",
		"color": Color(0.4, 0.4, 0.4)
	}
}

func assign_theme_from_seed(seed_string: String):
	var seed_name = seed_string.strip_edges().to_lower()
	for key in THEME_TABLE.keys():
		if seed_name.find(key) >= 0:
			set_theme(key)
			return
	set_theme("default")

func set_theme(theme_key: String):
	current_theme = theme_key
	var theme_data = THEME_TABLE.get(theme_key, THEME_TABLE["default"])
	tileset_name = theme_data["tileset"]
	palette = theme_data["color"]

func get_tileset_path() -> String:
	return "res://Assets/Tiles/" + tileset_name
