extends Node
# ShopManager.gd - Handles daily shop refresh and inventory by shop type

var shop_data := {}
var prices := {
    "blacksmith": 1.0,
    "magic": 1.2,
    "general": 0.9,
    "potion": 1.1
}

func _ready():
    load_shop_data()
    refresh_all_shops_if_needed()

func load_shop_data():
    if FileAccess.file_exists("user://shop_data.json"):
        var file = FileAccess.open("user://shop_data.json", FileAccess.READ)
        var json = JSON.parse_string(file.get_as_text())
        if typeof(json) == TYPE_DICTIONARY:
            shop_data = json

func save_shop_data():
    var file = FileAccess.open("user://shop_data.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(shop_data))

func refresh_all_shops_if_needed():
    var current_day = WorldTime.current_day
    for shop_type in prices.keys():
        if not shop_data.has(shop_type) or shop_data[shop_type].get("last_refreshed", -1) < current_day:
            refresh_shop(shop_type)
            shop_data[shop_type]["last_refreshed"] = current_day
    save_shop_data()

func refresh_shop(shop_type: String):
    var items = []
    var all_items = load_items_pool()
    for i in range(5):
        var item = all_items[randi() % all_items.size()]
        items.append(item)
    shop_data[shop_type] = {
        "items": items,
        "last_refreshed": WorldTime.current_day
    }

func load_items_pool():
    var path = "res://Data/items.json"
    if FileAccess.file_exists(path):
        var file = FileAccess.open(path, FileAccess.READ)
        var result = JSON.parse_string(file.get_as_text())
        if typeof(result) == TYPE_DICTIONARY:
            return result.keys()
    return []

func get_items_for_shop(shop_type: String) -> Array:
    return shop_data.get(shop_type, {}).get("items", [])

func get_price_modifier(shop_type: String) -> float:
    return prices.get(shop_type, 1.0)
