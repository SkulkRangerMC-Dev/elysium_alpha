class_name Quest
extends Resource

enum State { INACTIVE, ACTIVE, COMPLETED, REWARDED }

@export var id: String
@export var title: String
@export var description: String

# Each requirement: an ItemData.Type plus an amount.
@export var required_items: Array[ItemRequirement] = []

@export var reward_items: Array[ItemRequirement] = []

var state: State = State.INACTIVE
