extends CharacterBody2D

@export var speed := 200.0

var inventory: Array = []
var max_hp := 10
var current_hp := 10
var xp := 0
var level := 1
var xp_to_next_level := 50

func _ready():
	print("✅ Player position:", global_position)
	if get_parent().has_node("TileMap"):
		print("🧱 TileMap at:", get_parent().get_node("TileMap").global_position)

func _physics_process(_delta):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

func add_item(item_id: String):
	inventory.append(item_id)
	print("👜 Added item:", item_id)
	if Engine.has_singleton("InventoryUI"):
		var inventory_ui = get_node_or_null("/root/Main/UI/InventoryUI")
		if inventory_ui:
			inventory_ui.update_inventory(inventory)

func receive_damage(amount: int):
	current_hp -= amount
	print("💥 Player took damage! HP:", current_hp)
	if current_hp <= 0:
		print("☠️ Player defeated!")

func award_experience(amount: int):
	xp += amount
	print("✨ Gained XP:", amount)
	if xp >= xp_to_next_level:
		level += 1
		xp -= xp_to_next_level
		xp_to_next_level += 25  # optional scaling
		print("⬆️ Level Up! Now level", level)
