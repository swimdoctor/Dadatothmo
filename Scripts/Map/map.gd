extends Node2D

var mapLength: int = 10
var mapMaxHeight: int = 7

var mapNodes: Array[Array] = []

func _ready() -> void:
	buildNodes()
	connectNodes()

## Builds a graph made of MapNode objects. Generates in a 1-?-1 structure
## where the ? is pseudo randomized using curated parameters to set the number of vertical slices and horizontal slices.
func buildNodes() -> void:
	
	for i in range(mapLength):
		# Determine how many nodes to generate in the i-th vertical slice
		var maxSliceHeight = mapMaxHeight
		var minSliceHeight = 2
		if i == 0 or i == mapLength - 1:
			maxSliceHeight = 1
			minSliceHeight = 1
		elif i == 1 or i == mapLength - 2:
			maxSliceHeight = 3
		
		var sliceHeight = randi_range(minSliceHeight, maxSliceHeight)
		print(sliceHeight)
		
		# then fill out each node in the vertical slice with a MapNode
		mapNodes.append([])
		for j in range(sliceHeight):
			var nodePos: Vector2 = Vector2()
			nodePos.x = 100 + i * 100
			nodePos.y = 324 - (int)(80 * (sliceHeight - 1) / 2) + 80 * j
			# TODO: (easily adjustably) randomize NodeType so we can mess with the percentages
			mapNodes[i].append(MapNode.new(nodePos, MapNode.MapNodeType.Enemy))
			add_child(mapNodes[i][j])

## Connects MapNodes in a logical fashion
func connectNodes() -> void:
	# go through each column to connect everything
	for i in range(mapLength - 1):
		var currentColumn = mapNodes[i]
		var nextColumn = mapNodes[i + 1]
		for j in range(currentColumn.size()):
			var currentNode = currentColumn[j]
			
			# go through each node in the next column and connect based on the current state of connections
			for k in range(nextColumn.size()):
				var nextNodeAbove = nextColumn[k - 1] if k > 0 else null
				var nextNode = nextColumn[k]
				var nextNodeBelow = nextColumn[k + 1] if k < nextColumn.size() - 1 else null
				
				# conditionals to go through all connection scenarios
				# TODO: change these conditionals to actually connect the graph
				if (nextNodeBelow != null &&
					nextNode.hasIncomingConnection && 
					nextNodeBelow.hasIncomingConnection):
					continue
				elif (currentNode.connections == []):
					nextNode.hasIncomingConnection = true;
					currentNode.connections.append(nextNode)
				elif (nextNodeBelow != null &&
					nextNode.hasIncomingConnection && 
					!nextNodeBelow.hasIncomingConnection):
					if (randf() > 0.5):
						nextNode.hasIncomingConnection = true;
						currentNode.connections.append(nextNode)
				elif (nextNodeAbove == null ||
					(nextNodeAbove.hasIncomingConnection && 
					!nextNode.hasIncomingConnection)):
					if (randf() > 0.5):
						nextNode.hasIncomingConnection = true;
						currentNode.connections.append(nextNode)
					elif (nextNodeBelow != null):
						continue
				#elif (!nextNode.hasIncomingConnection):
					#nextNode.hasIncomingConnection = true;
					#currentNode.connections.append(nextNode)
				else:
					print("somehing has gone wrong with connecting nodes")
				
			print(currentNode.connections)
