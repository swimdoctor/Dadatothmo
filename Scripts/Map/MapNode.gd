class_name MapNode
extends Sprite2D

enum MapNodeType {
	Enemy,
	NPC,
	Loot,
	Hidden
}

var nodeType: MapNodeType = MapNodeType.Enemy
var connections: Array[MapNode] = []


func _init(_position: Vector2, _nodeType: MapNodeType) -> void:
	nodeType = _nodeType
	position = _position
	
	match nodeType:
		MapNodeType.Enemy:
			texture = load("res://Images/Test/Map/Frog.png")
		_:
			print("MapNodeTypes Sprite Not Found")
