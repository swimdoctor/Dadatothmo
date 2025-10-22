class_name Move
extends Resource

enum Note {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var name: String = ""
@export var icon: Texture2D = null
@export var notes: Array[Note] = []

func _init(name = "", icon = null, notes: Array[Note] = []):
	self.icon = icon
	self.name = name
	self.notes = notes

func getString():
	var string = "%-12s" %name;
	string = string + ": "
	for note in notes:
		string = string + getNoteString(note) + " "
	return string

static func getNoteString(note: Note):
	match note:
		Note.UP:
			return "UP   "
		Note.DOWN:
			return "DOWN "
		Note.LEFT:
			return "LEFT "
		Note.RIGHT:
			return "RIGHT"
	
	return "Invalid"
			
