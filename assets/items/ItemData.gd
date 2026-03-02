class_name ItemData
extends Resource

enum Type {COCONUT, APPLE, DRAGONFRUIT, LEMON, POTATO, BAKED_POTATO, MAIN}

@export var type: Type
@export var name: String
@export var texture: Texture2D
@export var max_stack_size: int = 20
@export var stackable: bool
@export var is_consumable: bool = true
@export var health_restore: int = 0
