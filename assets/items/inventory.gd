#class_name Inventory
#extends CanvasLayer
#
#var InvSize = 24
#var ItemLoad = [
	#"res://assets/items/coconut.tres",
	#"res://assets/items/coconut.tres",
	#"res://assets/items/coconut.tres",
	#"res://assets/items/coconut.tres"
#]
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#self.visible = false
	#for i in InvSize:
		#var slot := InventorySlot.new()
		#slot.init(ItemData.Type.MAIN, Vector2(64, 64))
		#%Inv.add_child(slot)
		#
	#for i in ItemLoad.size():
		#var item:= InventoryItem.new()
		#item.init(load(ItemLoad[i]))
		#%Inv.get_child(i).add_child(item)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("open_inv"):
		#self.visible =! self.visible
		#
	#if Input.is_action_just_pressed("interact"):
		#ItemLoad.append("res://assets/items/coconut.tres")
		#print("test")

class_name Inventory
extends CanvasLayer

signal item_picked_up(item_data: ItemData)
@export var player: Node

var InvSize = 24
var ItemLoad = [
]

func _ready() -> void:
	visible = false

	# Create slots
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(64, 64))
		slot.inventory = self
		%Inv.add_child(slot)

		print("Slot count: ", %Inv.get_child_count())

	# Initial items (optional)
	for i in ItemLoad.size():
		var item := InventoryItem.new()
		item.init(load(ItemLoad[i]))
		%Inv.get_child(i).add_child(item)

# PUBLIC: called by pickups / other scripts
func add_item(data: ItemData) -> bool:
	if data == null:
		push_error("add_item called with null data")
		return false

	# 1) Try to stack in existing items
	for i in %Inv.get_child_count():
		var slot := %Inv.get_child(i) as InventorySlot
		if slot.get_child_count() == 1:
			var existing_item := slot.get_child(0) as InventoryItem
			if existing_item.data.type == data.type \
			and data.stackable \
			and existing_item.quantity < data.max_stack_size:
				existing_item.add_one()
				item_picked_up.emit(data)
				return true

	# 2) Find an empty slot
	for i in %Inv.get_child_count():
		var slot2 := %Inv.get_child(i) as InventorySlot
		if slot2.get_child_count() == 0:
			var new_item := InventoryItem.new()
			new_item.init(data)
			slot2.add_child(new_item)
			item_picked_up.emit(data)
			return true

	# 3) Inventory full
	return false

func get_item_count(item_type: ItemData.Type) -> int:
	var total: int = 0
	for i in %Inv.get_child_count():
		var slot := %Inv.get_child(i) as InventorySlot
		if slot.get_child_count() == 1:
			var item := slot.get_child(0) as InventoryItem
			if item.data.type == item_type:
				total += item.quantity
	return total


func remove_item(item_type: ItemData.Type, amount: int = 1) -> void:
	var remaining: int = amount

	for i in %Inv.get_child_count():
		if remaining <= 0:
			break

		var slot := %Inv.get_child(i) as InventorySlot
		if slot.get_child_count() == 1:
			var item := slot.get_child(0) as InventoryItem
			if item.data.type == item_type:
				var take: int = min(item.quantity, remaining)
				item.quantity -= take
				remaining -= take

				# If stack is empty, remove the node
				if item.quantity <= 0:
					item.queue_free()


func add_item_type(item_type: ItemData.Type, amount: int = 1) -> void:
	# Find any ItemData with this type in ItemLoad or via a lookup.
	# If you already have a way to get ItemData from type, use that.
	var data: ItemData = null

	# Simple example: if you keep a global item database, replace this:
	for path in ItemLoad:
		var loaded := load(path) as ItemData
		if loaded.type == item_type:
			data = loaded
			break

	if data == null:
		push_error("add_item_type: no ItemData found for type %s" % [str(item_type)])
		return

	for i in amount:
		add_item(data)

func get_all_items() -> Array:
	var result: Array = []
	for i in %Inv.get_child_count():
		var slot := %Inv.get_child(i) as InventorySlot
		if slot.get_child_count() == 1:
			var item := slot.get_child(0) as InventoryItem
			result.append(item)
	return result

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inv"):
		visible = !visible
	if Input.is_action_just_pressed("interact"):
		var items = get_all_items()
		for item in items:
			print(item.data.name, " x", item.quantity)
		print("test")
