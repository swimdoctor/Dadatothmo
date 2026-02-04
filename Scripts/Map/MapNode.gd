class_name MapNode
extends Area2D

# Children of the area2d
var sprite: Sprite2D
var collision: CollisionShape2D

enum MapNodeType {
	Enemy,
	NPC,
	Loot,
	Hidden
}

var nodeType: MapNodeType = MapNodeType.Enemy
var connections: Array[MapNode] = []

var connectionCount: int = 0

## Map node factory constructor.
static func create(_position: Vector2, _size: Vector2, _nodeType: MapNodeType) -> MapNode:
	var node: MapNode = MapNode.new()
	
	node.nodeType = _nodeType
	node.position = _position
	
	# Sprite
	node.sprite = Sprite2D.new()
	node.sprite.texture = preload("res://Images/Test/Map/Frog.png")
	
	# CollisionShape
	node.collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = _size
	node.collision.shape = shape
	
	# MapNode specific stuff
	match node.nodeType:
		MapNodeType.Enemy:
			node.sprite.texture = preload("res://Images/Test/Map/Frog.png")
		_:
			print("MapNodeTypes Sprite Not Found")
			
	node.add_child(node.sprite)
	node.add_child(node.collision)
	
	return node

func _draw() -> void:
	for i in range(connections.size()):
		draw_line(
			Vector2.ZERO,
			Vector2(connections[i].position - self.position),
			Color.BLACK,
			4.0
		)

## Adds a node to connections array and increases count of connections
func appendNode(_node: MapNode) -> void:
	connections.append(_node)
	_node.connectionCount += 1

## When node is clicked
func _input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed):
		print("Sprite clicked!")
