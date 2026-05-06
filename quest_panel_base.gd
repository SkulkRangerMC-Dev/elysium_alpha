extends Panel

@onready var quest_img_slot: TextureRect = $TextureRect
@onready var quest_heading: Label = $Heading
@onready var quest_desc: Label = $Heading/ScrollContainer/Description

func _ready() -> void:
	print("QuestPanel _ready, self:", self)
	print("  TextureRect node:", $TextureRect)

func set_quest_panel_detail(img: Texture2D, head: String, desc: String = "") -> void:
	print("quest_add called with:", img, " ", head,"", desc)
	print("quest_img_slot:", quest_img_slot)
	if quest_img_slot == null:
		push_error("quest_img_slot is null; check node path.")
		return
 
	$TextureRect.texture = img
	$Heading.text = head
	$Heading/ScrollContainer/Description.text = desc
 
func delete_quest():
	queue_free()
