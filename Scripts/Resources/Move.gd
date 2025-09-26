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
