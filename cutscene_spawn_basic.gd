extends Area3D

var cutscene_file = load("res://assets/2D/textbox.tscn") as PackedScene
var fadein_file = load("res://assets/2D/fadein-out.tscn") as PackedScene
var itemobtained: bool = false
var quest_got: bool = false	 
var got_dem_nuts: bool = false
var quest_have = false	


# NOTE: We removed the .instantiate() variables from here. 
# We must do that inside the function, otherwise the game crashes 
# if you trigger this event twice.

# NOTE: We removed @onready var animation_player. 
# It doesn't exist in the Area3D, it exists inside the fadein file.

func _process(delta) -> void:
	if Input.is_action_just_pressed("interact"):
		itemobtained = !itemobtained
		print("itemobtained: ", itemobtained)

	if Input.is_action_just_pressed("interact"):
		got_dem_nuts = true
		print("got dem nuts")
func _on_body_entered(body: Node3D) -> void:
	# check if the body is the player (using name is safer if you didn't add class_name Player)
	if body.name == "Player":
		print("test")
		var cutscene_inst = cutscene_file.instantiate()
		add_child(cutscene_inst)
		if quest_got == false:
			cutscene_inst.say_left("I think I finally figured the panel out.", cutscene_inst.placeholder)
			cutscene_inst.say_left("A long time ago, there were people who lived across the archipelago. These were the ones that Plato referred to as the Atlantean Race in his records.", cutscene_inst.placeholder)
			cutscene_inst.say_left("It seems they were experimenting on... a sort of, soul energy? It is quite strange but that's what it says.", cutscene_inst.placeholder)
			cutscene_inst.say_left("...", cutscene_inst.placeholder)
			cutscene_inst.say_left("So you have found me, haven't you.", cutscene_inst.thelostone)
			quest_got = true
			$/root/Main/Player/Quests.add_quest(load("res://assets/2D/textures/characters/Robot.png"), "The Mural of the Ancients - Part I", "Wait for Manolis to decode the first panel of the Mural of the Ancients. You should probably go hunt for some stuff or defeat the strange mechanical things that are roaming the caverns.")
			quest_have = true
