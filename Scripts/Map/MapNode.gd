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

var highlighted: bool = false
var occupied: bool = false

var nodeType: MapNodeType = MapNodeType.Enemy
var connections: Array[MapNode] = []
var incomingConnections: Array[MapNode] = []

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
		
	if (highlighted):
		draw_circle(Vector2.ZERO, 15, Color.YELLOW)
		
	if (occupied):
		draw_circle(Vector2.ZERO, 15, Color.BLACK)

## Adds a node to connections array and increases count of connections
func appendNode(_node: MapNode) -> void:
	connections.append(_node)
	_node.incomingConnections.append(self)

# When node is clicked
func _input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed
	and highlighted):
		#TODO: Add an NPC and a Hidden state change in , then make those nodes not GameOver
		match nodeType:
			MapNodeType.Enemy:
				gamemanager.change_gamestate(GameManager.GameState.Fighting)
			MapNodeType.NPC:
				print("TODO: implement NPC scene")
				gamemanager.change_gamestate(GameManager.GameState.GameOver)
			MapNodeType.Loot:
				gamemanager.change_gamestate(GameManager.GameState.Upgrading)
			MapNodeType.Hidden:
				print("TODO: implement hidden scene")
				gamemanager.change_gamestate(GameManager.GameState.GameOver)
		playerMovesOn()

func playerMovesOn() -> void:
	occupied = true
	
	for connection in connections:
		connection.highlighted = true
		connection.queue_redraw()
		
	for connection in incomingConnections:
		if (connection.occupied):
			for c in connection.connections:
				c.highlighted = false
				c.queue_redraw()
		connection.occupied = false
		connection.queue_redraw()
		
	queue_redraw()
