#extends CharacterBody3D
#class_name Player
#
## How fast the player moves in meters per second.
#@export var speed = 14
## The downward acceleration when in the air, in meters per second squared.
#@export var fall_acceleration = 75
#@export var health = 100
#@export var max_health = 100
#@export var fainted_state = false
#@export var in_conversation = false
#var spawnpoint = Vector3(0, -0.5, 10)
#var fadein_file = load("res://assets/2D/fadein-out.tscn") as PackedScene
#@export var cooking_menu_scene: PackedScene 
#@onready var inventory: Inventory = $InventoryCanvas  # adjust path
#
#func get_inventory() -> Inventory:
	#return inventory
#
#var target_velocity = Vector3.ZERO
#
#func _physics_process(delta):
	#var direction = Vector3.ZERO
#
	#if fainted_state or in_conversation == false:
		#if Input.is_action_pressed("move_right"):
				#direction.x += 1
		#if Input.is_action_pressed("move_left"):
				#direction.x -= 1
		#if Input.is_action_pressed("move_backward"):
				#direction.z += 1
		#if Input.is_action_pressed("move_forward"):
				#direction.z -= 1
			 #
	#if direction != Vector3.ZERO:
		#direction = direction.normalized()
		#var current_basis = $Pivot.basis
		#var target_basis = Basis.looking_at(direction, Vector3.UP)
		#$Pivot.basis = current_basis.slerp(target_basis, delta * 5)  # 5 = rotation speed
#
#
	## Ground Velocity
	#target_velocity.x = direction.x * speed
	#target_velocity.z = direction.z * speed
#
	## Vertical Velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)
#
	## Moving the Character
	#velocity = target_velocity
	#move_and_slide()
#
#func restore_health(amount: int) -> void:
	#if amount <= 0:
		#return
	#health = min(health + amount, max_health)
	#print("Health now: ", health)
#
#func _process(delta: float) -> void:
	#
	## Slowing Down
	#if health <= 35:
		#speed = 7
	#else:
		#speed = 14
	## Death
	#if health <= 0:
		#var new_fadein = fadein_file.instantiate()
		#add_child(new_fadein)
		#var anim = new_fadein.get_node("AnimationPlayer")
		#fainted_state = true
		#anim.play("fade_out")
		#health = 100
		#await get_tree().create_timer(2.0).timeout
		#position = spawnpoint
		#fainted_state = false
		#anim.play("fade_in")
		#print("player health is now ", health)

extends CharacterBody3D
class_name Player

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var health = 100
@export var max_health = 100
@export var fainted_state = false
@export var in_conversation = false

var spawnpoint = Vector3(0, -0.5, 10)
var fadein_file = load("res://assets/2D/fadein-out.tscn") as PackedScene

@onready var inventory: Inventory = $InventoryCanvas
@onready var cooking_menu: CookingMenu = $CookingMenu

var target_velocity = Vector3.ZERO

func get_inventory() -> Inventory:
	return inventory

func _physics_process(delta):
	var direction = Vector3.ZERO

	if fainted_state or in_conversation == false:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_backward"):
			direction.z += 1
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var current_basis = $Pivot.basis
		var target_basis = Basis.looking_at(direction, Vector3.UP)
		$Pivot.basis = current_basis.slerp(target_basis, delta * 5)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func restore_health(amount: int) -> void:
	if amount <= 0:
		return
	health = min(health + amount, max_health)
	print("Health now: ", health)

func _process(delta: float) -> void:
	# Slowing Down
	if health <= 35:
		speed = 7
	else:
		speed = 14

	# Death
	if health <= 0:
		var new_fadein = fadein_file.instantiate()
		add_child(new_fadein)
		var anim = new_fadein.get_node("AnimationPlayer")
		fainted_state = true
		anim.play("fade_out")
		health = 100
		await get_tree().create_timer(2.0).timeout
		position = spawnpoint
		fainted_state = false
		anim.play("fade_in")
		print("player health is now ", health)

func _input(event: InputEvent) -> void:
	# Toggle cooking menu with the "cooking_menu" action (mapped to C)
	if event.is_action_pressed("cooking_menu"):
		if cooking_menu.visible:
			cooking_menu.close()
		else:
			_open_cooking_menu()

func _open_cooking_menu() -> void:
	# Replace this with your real campfire detection logic
	var at_campfire := false
	cooking_menu.open(inventory, at_campfire)
