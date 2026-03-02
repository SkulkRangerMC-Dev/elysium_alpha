# res://ui/CookingMenu.gd
extends CanvasLayer

@export var recipes: Array[Recipe] = []

var inventory: Inventory = null
var at_campfire: bool = false
var current_recipe: Recipe = null

@onready var recipe_list_vbox: VBoxContainer = $Panel/MarginContainer/HBoxContainer/RecipeList
@onready var dish_icon: TextureRect = $Panel/MarginContainer/HBoxContainer/VBoxContainer2/MarginContainer/DishIcon
@onready var ingredients_grid: GridContainer = $Panel/MarginContainer/HBoxContainer/VBoxContainer2/MarginContainer2/IngredientsGrid
@onready var cook_button: Button = $Panel/MarginContainer/HBoxContainer/VBoxContainer2/CookButton

func _ready() -> void:
	visible = false
	cook_button.pressed.connect(_on_cook_pressed)
	_build_recipe_buttons()

func open(inv: Inventory, is_at_campfire: bool) -> void:
	inventory = inv
	at_campfire = is_at_campfire
	visible = true
	get_tree().paused = true

	# Default to first recipe if any
	if recipes.size() > 0:
		current_recipe = recipes[0]
	else:
		current_recipe = null

	_clear_ingredient_slots()
	dish_icon.texture = null
	_update_detail_panel()

func close() -> void:
	visible = false
	get_tree().paused = false
	current_recipe = null

func _build_recipe_buttons() -> void:
	for c in recipe_list_vbox.get_children():
		c.queue_free()

	for r in recipes:
		if r == null or r.result_item == null:
			continue

		var btn := Button.new()
		btn.text = r.display_name if r.display_name != "" else r.result_item.name
		btn.icon = r.result_item.texture
		btn.expand_icon = true
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		btn.pressed.connect(_on_recipe_button_pressed.bind(r))
		recipe_list_vbox.add_child(btn)

func _on_recipe_button_pressed(recipe: Recipe) -> void:
	current_recipe = recipe
	_update_detail_panel()

func _update_detail_panel() -> void:
	_clear_ingredient_slots()

	if current_recipe == null or current_recipe.result_item == null:
		dish_icon.texture = null
		cook_button.disabled = true
		return

	dish_icon.texture = current_recipe.result_item.texture

	var slots := ingredients_grid.get_children()
	for i in range(slots.size()):
		var slot := slots[i] as TextureRect

		if i < current_recipe.ingredient_items.size():
			var item_data: ItemData = current_recipe.ingredient_items[i]
			if item_data == null:
				slot.texture = null
				slot.modulate = Color(1, 1, 1)
				continue

			slot.texture = item_data.texture

			if inventory != null:
				var have: int = inventory.get_item_count(item_data.type)
				if have > 0:
					slot.modulate = Color(1, 1, 1)
				else:
					slot.modulate = Color(1, 0.5, 0.5)
			else:
				slot.modulate = Color(1, 1, 1)
		else:
			slot.texture = null
			slot.modulate = Color(1, 1, 1)

	cook_button.disabled = not _can_cook_current()

func _clear_ingredient_slots() -> void:
	for c in ingredients_grid.get_children():
		var slot := c as TextureRect
		slot.texture = null
		slot.modulate = Color(1, 1, 1)

func _can_cook_current() -> bool:
	if current_recipe == null or inventory == null:
		return false

	if current_recipe.requires_campfire and not at_campfire:
		return false

	for item_data in current_recipe.ingredient_items:
		if item_data == null:
			return false
		if inventory.get_item_count(item_data.type) <= 0:
			return false

	return true

func _on_cook_pressed() -> void:
	Input.is_action_pressed("cooking_menu")
	if not _can_cook_current():
		return

	# Consume 1 of each ingredient
	for item_data in current_recipe.ingredient_items:
		if item_data != null:
			inventory.remove_item(item_data.type, 1)

	# Give result (using ItemData in inventory)
	if current_recipe.result_item != null:
		inventory.add_item(current_recipe.result_item)

	_update_detail_panel()
