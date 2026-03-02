extends Area3D

var cutscene_file = load("res://assets/2D/cutscene_ui.tscn") as PackedScene
var fadein_file = load("res://assets/2D/fadein-out.tscn") as PackedScene

# NOTE: We removed the .instantiate() variables from here. 
# We must do that inside the function, otherwise the game crashes 
# if you trigger this event twice.

# NOTE: We removed @onready var animation_player. 
# It doesn't exist in the Area3D, it exists inside the fadein file.

func _on_body_entered(body: Node3D) -> void:
	# check if the body is the player (using name is safer if you didn't add class_name Player)
	if body.name == "Player":
		print("test")
		var cutscene_inst = cutscene_file.instantiate()
		add_child(cutscene_inst)
		
		cutscene_inst.start_conversation([
			{"text": "are you sure about this?"},
			{"text": "definitely, why not?"},
			{"text": "youre dumb"},
			{"text": "ok..."}
			],
			body
			)
		print("Conversation started on instance!")	

		# PlayerHurt
		body.health -= 20
		print("Player health is ", body.health)
