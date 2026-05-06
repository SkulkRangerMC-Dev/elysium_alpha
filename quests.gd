extends CanvasLayer  # or Control, whatever Quests uses
class_name Quests  # <- add this line

@onready var quest_container: VBoxContainer = $MarginContainer/Panel/MarginContainer/ScrollContainer/QuestContainer
var quest_panel_scene: PackedScene = load("res://assets/2D/questpanel.tscn") as PackedScene

func add_quest(img: Texture2D, head: String, desc: String = "") -> void:
	var panel_inst := quest_panel_scene.instantiate()
	quest_container.add_child(panel_inst)
	panel_inst.set_quest_panel_detail(img, head, desc)
func _ready():
	visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quest_open"):
		visible = !visible	

func delete_panel():
	quest_container.queue_free()
