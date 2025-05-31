extends Control

@onready var item_list = $ItemList
@onready var gold_label = $GoldLabel
@onready var buy_button = $BuyButton
@onready var sell_button = $SellButton
@onready var confirm_button = $ConfirmButton
@onready var cancel_button = $CancelButton

var player
var shop_manager
var is_buying = true
var selected_item = null

func setup(p, shop):
	player = p
	shop_manager = shop
	is_buying = true
	_refresh_gold()
	_refresh_items()

func _ready():
	buy_button.pressed.connect(_on_buy_pressed)
	sell_button.pressed.connect(_on_sell_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	item_list.item_selected.connect(_on_item_selected)

func _refresh_gold():
	gold_label.text = "Gold: %d" % player.gold

func _refresh_items():
	item_list.clear()
	selected_item = null
	if is_buying:
		for item in shop_manager.get_items_for_sale():
			item_list.add_item("%s - %d gold" % [item.name, item.price])
	else:
		for _item_name in player.inventory.get_all_items():
			var qty = player.get_item_quantity(name)
			var price = shop_manager.get_sell_price(name)
			item_list.add_item("%s x%d - %d gold each" % [name, qty, price])

func _on_buy_pressed():
	is_buying = true
	_refresh_items()

func _on_sell_pressed():
	is_buying = false
	_refresh_items()

func _on_item_selected(index):
	selected_item = item_list.get_item_text(index)

func _on_confirm_pressed():
	if selected_item == null:
		return

	if is_buying:
		var _item_name = selected_item.split(" - ")[0]
		var price = shop_manager.get_price(name)
		if player.gold >= price:
			player.gold -= price
			player.add_item(name)
	else:
		var _item_name = selected_item.split(" x")[0]
		if player.get_item_quantity(name) > 0:
			var price = shop_manager.get_sell_price(name)
			player.gold += price
			player.remove_item(name)

	_refresh_gold()
	_refresh_items()

func _on_cancel_pressed():
	hide()
