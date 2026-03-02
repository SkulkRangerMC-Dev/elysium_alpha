class_name InventorySlot
extends PanelContainer

@export var type: ItemData.Type
var inventory: Inventory
	
func init(t: ItemData.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms
