extends CanvasLayer

var current_dialogue = []
var current_line = 0
var dialogue_active = false
var player: Node = null   # <- store player here

@onready var dialogue_label: RichTextLabel = $BottomAnim/BgBarBottom/TextboxA
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var voice_player: AudioStreamPlayer = $voice_player  # Add this

func show_current_line():
	if current_line < 0 or current_line >= current_dialogue.size():
		print("show_current_line: index out of range: ", current_line)
		return

	print("show_current_line called, line: ", current_line)
	var line = current_dialogue[current_line]
	print("Line data: ", line)
	dialogue_label.text = line.get("text", "NO TEXT")
	dialogue_label.queue_redraw()

	if "voice" in line:
		voice_player.stream = load(line.voice)
		voice_player.play()
	else:
		pass

# Optional: Wait for voice to finish before advancing (uncomment in _input/advance_line)
# func _input	(event): ...
#     if voice_player.playing: return  # Block input during voice

func _ready():
	# Start fully invisible/offscreen via default pose or initial keys
	anim_player.play("RESET")  # Ensures hidden state
	anim_player.animation_finished.connect(_on_anim_finished)
	print("Signal connected!")  # Confirm

func _input(event):
	if Input.is_action_pressed("converse_progress"):
		advance_line()
		
func start_conversation(lines: Array, player_ref: Node):
	player = player_ref
	player_ref.in_conversation = true
	current_dialogue = lines
	current_line = 0
	dialogue_active = true
	show_current_line()
	anim_player.play("textboxes_rise")

func advance_line():
	current_line += 1
	if current_line >= current_dialogue.size():
		end_conversation()

	else:
		anim_player.play("text_transition")
		await get_tree().create_timer(0.375).timeout
		show_current_line()
		await get_tree().create_timer(2).timeout
		print(dialogue_label.text)
		
func end_conversation():
	anim_player.play("textboxes_fall")  # Handles disappearing + despawn trigger
	player.in_conversation = false
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_anim_finished(anim_name: String):
	if anim_name == "textboxes_rise":
		show_current_line()


func reset_ui():
	dialogue_label.text = ""
	anim_player.play("RESET")  # Back to invisible state
