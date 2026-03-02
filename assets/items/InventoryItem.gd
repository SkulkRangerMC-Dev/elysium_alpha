##class_name InventoryItem
##extends TextureRect
##
##@export var data: ItemData
##
##func _ready() -> void:
	##expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	##stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
##
	##if data != null:
		##texture = data.texture
##
##func init(d: ItemData) -> void:
	##data = d
	##if data != null:
		##texture = data.texture

# the new code 1

#class_name InventoryItem
#extends TextureRect
#
#@export var data: ItemData
#var quantity: int = 1
#
#var qty_label: Label  # will be created in code
#
#func _ready() -> void:
	#expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#mouse_filter = Control.MOUSE_FILTER_STOP
#
	## Create quantity label dynamically
	#qty_label = Label.new()
	#qty_label.name = "QuantityLabel"
	#qty_label.text = ""
	#qty_label.anchor_right = 1.0
	#qty_label.anchor_bottom = 1.0
	#qty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	#qty_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	#qty_label.offset_right = -4
	#qty_label.offset_bottom = -4
	#add_child(qty_label)
#
	#if data != null:
		#texture = data.texture
	#_update_label()
#
#func init(d: ItemData) -> void:
	#data = d
	#quantity = 1
	#if data != null:
		#texture = data.texture
	#_update_label()
#
#func add_one() -> void:
	#if data == null:
		#return
	#if not data.stackable:
		#return
	#if quantity < data.max_stack_size:
		#quantity += 1
	#_update_label()
#
#func _update_label() -> void:
	#if qty_label == null:
		#return
	#if quantity <= 1:
		#qty_label.text = ""
	#else:
		#qty_label.text = str(quantity)

## the new code 2

class_name InventoryItem
extends TextureRect

@export var data: ItemData
var quantity: int = 1

var qty_label: Label

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Create quantity label dynamically (as before)
	qty_label = Label.new()
	qty_label.name = "QuantityLabel"
	qty_label.anchor_right = 1.0
	qty_label.anchor_bottom = 1.0
	qty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	qty_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	qty_label.offset_right = -4
	qty_label.offset_bottom = -4
	add_child(qty_label)

	if data != null:
		texture = data.texture
	_update_label()

func init(d: ItemData) -> void:
	data = d
	quantity = 1
	if data != null:
		texture = data.texture
	_update_label()

func add_one() -> void:
	if data == null:
		return
	if not data.stackable:
		return
	if quantity < data.max_stack_size:
		quantity += 1
	_update_label()

func _update_label() -> void:
	if qty_label == null:
		return
	if quantity <= 1:
		qty_label.text = ""
	else:
		qty_label.text = str(quantity)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_click()

func _on_click() -> void:
	if data == null:
		return
	if not data.is_consumable:
		return  # ignore non-consumable items

	# Find owning slot and inventory
	var slot := get_parent() as InventorySlot
	if slot == null:
		return
	var inv := slot.inventory
	if inv == null:
		return

	# Call player's restore_energy based on this item
	if inv.player and inv.player.has_method("restore_health"):
		inv.player.restore_health(data.health_restore)

	_consume_one()

func _consume_one() -> void:
	quantity -= 1
	if quantity <= 0:
		queue_free()  # remove from slot completely
	else:
		_update_label()
