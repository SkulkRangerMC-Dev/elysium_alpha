extends CanvasLayer
var CHAR_READ_RATE := 0.05

@onready var textbox_container: Control = $TextboxContainer
@onready var label: Label = $TextboxContainer/MarginContainer/Panel/Label
@onready var cont_text: Label = $TextboxContainer/MarginContainer/Panel/Continue
@onready var left_cutout: TextureRect = $LeftCutout
@onready var right_cutout: TextureRect = $RightCutout
@onready var player = $root/Main/Player
var placeholder =  "res://assets/2D/textures/characters/placeholdericon.png"
var thelostone =  "res://assets/2D/textures/characters/placeholderhypericon.png"

var tween: Tween = null

enum State {
	READY,
	READING,
	FINISHED
}

var current_state: State = State.READY
var text_queue: Array = []

func _ready() -> void:
	hide_textbox()
	hide_l_cutout()
	right_cutout.flip_h = true
	hide_r_cutout()

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			emit_signal("player_freezing")
			if not text_queue.is_empty():
				display_text()

		State.READING:
			if Input.is_action_just_pressed("converse_progress"):
				# Skip to end of text
				if tween and tween.is_running():
					tween.kill() # stop tween
				label.visible_ratio = 1.0
				change_state(State.FINISHED)

		State.FINISHED:
			if Input.is_action_just_pressed("converse_progress"):
				if text_queue.is_empty():
					hide_textbox()
					queue_free()
				change_state(State.READY)

func say_left(text: String, portrait_path: String = "") -> void:
	queue_text(text, "left", portrait_path)

func say_right(text: String, portrait_path: String = "") -> void:
	queue_text(text, "right", portrait_path)

func start_dialogue() -> void:
	# Optional: ensure visible and reset state
	hide_textbox()
	show_textbox()
	current_state = State.READY

func queue_text(text: String, side: String, portrait_path: String = "") -> void:
	text_queue.push_back({
		"text": text,
		"side": side,
		"portrait_path": portrait_path,
	})
	
func hide_textbox() -> void:
	cont_text.text = ""
	label.text = ""
	left_cutout.hide()
	right_cutout.hide()
	textbox_container.hide()

func show_textbox() -> void:
	textbox_container.show()

func display_text() -> void:
	var entry = text_queue.pop_front()

	var text: String = entry["text"]
	var side: String = entry["side"]
	var portrait_path: String = entry["portrait_path"]

	# Set speaker / portrait for THIS line
	if side == "left":
		if portrait_path != "":
			set_lc_tex(portrait_path)
		show_l_cutout()
		hide_r_cutout()
	elif side == "right":
		if portrait_path != "":
			set_rc_tex(portrait_path)
		show_r_cutout()
		hide_l_cutout()

	label.text = text
	label.visible_ratio = 0.0
	show_textbox()
	change_state(State.READING)

	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	var duration := text.length() * CHAR_READ_RATE
	tween.tween_property(label, "visible_ratio", 1.0, duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_tween_finished)

func change_state(next_state: State) -> void:
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
			cont_text.text = ""
		State.READING:
			print("Changing state to: State.READING")
			cont_text.text = ""
		State.FINISHED:
			print("Changing state to: State.FINISHED")
			cont_text.text = "(Click to continue)"

func _on_tween_finished() -> void:
	change_state(State.FINISHED)

func hide_l_cutout():
	left_cutout.hide()
	
func show_l_cutout():
	left_cutout.show()
	
func hide_r_cutout():
	right_cutout.hide()
	
func show_r_cutout():
	right_cutout.show()
	
func set_rc_tex(path):
	var tex: Texture2D = load(path)
	right_cutout.texture = tex
	
func set_lc_tex(path):
	var tex: Texture2D = load(path)
	left_cutout.texture = tex
