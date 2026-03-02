# res://data/Recipe.gd
extends Resource
class_name Recipe

@export var id: String                       # internal id if you want
@export var display_name: String             # text for UI buttons

@export var result_item: ItemData            # what dish you get when cooked
@export var ingredient_items: Array[ItemData] = []  # what you need

@export var requires_campfire: bool = true
