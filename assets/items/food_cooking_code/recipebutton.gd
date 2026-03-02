class_name RecipeButton
extends Button

var recipe: Recipe

func setup(r: Recipe) -> void:
	recipe = r
	text = r.display_name
