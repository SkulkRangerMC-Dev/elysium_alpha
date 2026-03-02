extends Area3D
@onready var inventory = get_node("/root/Main/Player/InventoryCanvas")  # Adjust path to your scene structure
@export var data: ItemData  # assign coconut.tres etc. in Inspector

func _on_body_entered(body: Node3D) -> void:
	# check if the body is the player (using name is safer if you didn't add class_name Player)
	if body.name == "Player":
		print("Collacted ", data.name)
		queue_free()
	if body.has_method("get_inventory"):
		var inv: Inventory = body.get_inventory()
		if inv.add_item(data):
			queue_free()  # picked up successfully
