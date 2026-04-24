class_name EnemyMove
extends Move


func _init(id = null, name = "", description = "", icon = null, move_func : Callable = Callable(self, "default_move"), sprite = null):
	self.id = id
	self.icon = icon
	self.name = name
	self.description = description
	self.move_func = move_func
	self.sprite = sprite
