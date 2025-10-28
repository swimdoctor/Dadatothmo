class_name Move
extends Resource

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var name: String = ""
@export var icon: Texture2D = null
@export var notes: Array[Direction] = []

func _init(name = "", icon = null, notes: Array[Direction] = []):
	self.icon = icon
	self.name = name
	self.notes = notes

func getString():
	var string = "%-12s" %name;
	string = string + ": "
	for note in notes:
		string = string + getNoteString(note) + " "
	return string

static func getNoteString(note: Direction):
	match note:
		Direction.UP:
			return "UP   "
		Direction.DOWN:
			return "DOWN "
		Direction.LEFT:
			return "LEFT "
		Direction.RIGHT:
			return "RIGHT"
	
	return "Invalid"

static func getNoteSprite(direction: Direction):
	match direction:
		Direction.UP:
			return preload("res://Images/Test/Arrow_Up.png")
		Direction.DOWN:
			return preload("res://Images/Test/Arrow_Down.png")
		Direction.LEFT:
			return preload("res://Images/Test/Arrow_Left.png")
		Direction.RIGHT:
			return preload("res://Images/Test/Arrow_Right.png")
	pass
	
