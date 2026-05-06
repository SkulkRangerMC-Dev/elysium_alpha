extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = load("res://assets/2D/textures/characters/Robot.png")
	$Heading.text = "Find out what the hell is happening."
	$Heading/ScrollContainer/Description.text = "Wait for Manolis to decode the first panel of the Mural of the Ancients. You should probably go hunt for some stuff or defeat the strange mechanical things that are roaming the caverns."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
