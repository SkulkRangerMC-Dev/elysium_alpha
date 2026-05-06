extends AudioStreamPlayer3D

var MesanGearShifts_Chorded = load("res://assets/music/MesanGearshifts_Chorded.mp3")
var Marshals = load("res://assets/music/1. Main Theme (1).mp3")
var Reservoir = load("res://assets/music/Reservoir_Theme_V2.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_stream(Reservoir)
	play()
	stream.loop = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
