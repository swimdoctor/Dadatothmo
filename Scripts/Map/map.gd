extends Node2D

var mapLength: int = 20
var mapMaxHeight: int = 15
var mapMaxDelta: int = 2

var mapNodes: Array[Array] = []

func _ready() -> void:
	buildNodes()
	connectNodes()
	#balanceNodes()

## Builds a graph made of MapNode objects. Generates in a 1-?-1 structure
## where the ? is pseudo randomized using curated parameters to set the number of vertical slices and horizontal slices.
func buildNodes() -> void:
	
	for i in range(mapLength):
		# Determine how many nodes to generate in the i-th vertical slice
		var sliceHeight: int
		if i == 0 or i == mapLength - 1:
			sliceHeight = 1
		else:
			var prevSliceHeight = mapNodes[i-1].size()
			var minSliceHeight = max(2, prevSliceHeight - mapMaxDelta)
			var maxSliceHeight = min(5, prevSliceHeight + mapMaxDelta, (mapLength - i - 1)*mapMaxDelta + 1)
			
			if maxSliceHeight < minSliceHeight:
				minSliceHeight = maxSliceHeight
			sliceHeight = randi_range(minSliceHeight, maxSliceHeight)
		print(sliceHeight)
		
		# then fill out each node in the vertical slice with a MapNode
		mapNodes.append([])
		for j in range(sliceHeight):
			var nodePos: Vector2 = Vector2()
			nodePos.x = 100 + i * 50
			nodePos.y = 324 - (int)(80 * (sliceHeight - 1) / 2) + 80 * j
			# TODO: (easily adjustably) randomize NodeType so we can mess with the percentages
			# TODO: change the Vector2 for size to use variables
			mapNodes[i].append(MapNode.create(nodePos, Vector2(10, 10), MapNode.MapNodeType.Enemy))
			add_child(mapNodes[i][j])

## Connects MapNodes in a logical fashion
func connectNodes() -> void:
	# go through each column to connect everything
	var i = 0;
	var errorCount = 0;
	while i < mapLength - 1:
		var currentColumn = mapNodes[i]
		var nextColumn = mapNodes[i + 1]
		
		var p: float = 0.5
		var targetInputsPerNode: float = 2.0
		
		#Geometric Series thingy only works on n > 1
		if currentColumn.size() < nextColumn.size():
			var connectionsPerNode = nextColumn.size() * targetInputsPerNode / currentColumn.size()
			#Geometric Series Math
			p = 1 / (connectionsPerNode / (connectionsPerNode - 1))
		#print(p)
		
		for j in range(currentColumn.size()):
			var currentNode = currentColumn[j]
			var currentNodeBelow = currentColumn[j + 1] if j < currentColumn.size() - 1 else null
			
			# go through each node in the next column and connect based on the current state of connections
			for k in range(nextColumn.size()):
				if nextColumn[k].incomingConnections.size() >= 3:
					continue;
				if currentNode.connections.size() >= 3:
					break;
				
				var nextNodeAbove = nextColumn[k - 1] if k > 0 else null
				var nextNode = nextColumn[k]
				var nextNodeBelow = nextColumn[k + 1] if k < nextColumn.size() - 1 else null
				
				# conditionals to go through all connection scenarios
				if (nextNodeBelow != null &&
					nextNode.incomingConnections.size() > 0 && 
					nextNodeBelow.incomingConnections.size() > 0):
					continue
				elif (currentNode.connections == []):
					currentNode.appendNode(nextNode)
				elif (nextNodeBelow != null &&
					nextNode.incomingConnections.size() > 0 && 
					nextNodeBelow.incomingConnections.size() == 0):
					if (randf() < p):
						currentNode.appendNode(nextNode)
				elif (nextNode.incomingConnections.size() == 0 &&
					currentNodeBelow == null):
					currentNode.appendNode(nextNode)
				elif (nextNodeAbove == null ||
					(nextNodeAbove.incomingConnections.size() > 0 && 
					nextNode.incomingConnections.size() == 0)):
					if (randf() < p):
						currentNode.appendNode(nextNode)
					elif (nextNodeBelow != null):
						continue
				else:
					print("something has gone wrong with connecting nodes")
				
			#print(currentNode.connections)
		
		var validMap = true;
		
		for node in currentColumn:
			if node.connections.size() == 0:
				validMap = false;
				break;
		
		for node in nextColumn:
			if node.incomingConnections.size() == 0:
				validMap = false;
				break;
		
		if validMap:
			i += 1;
			print("Errors: ", errorCount);
			errorCount = 0;
		else:
			errorCount += 1;
			if errorCount > 100:
				print("Map Not Generated");
				return;
			
			for node in currentColumn:
				node.connections.clear();
			for node in nextColumn:
				node.incomingConnections.clear();

func balanceNodes() -> void:
	for i in range(1, mapLength):
		for currentNode in mapNodes[i]:
			var y = 0
			
			for prevNode in currentNode.incomingConnections:
				y += prevNode.position.y
			
			y /= currentNode.incomingConnections.size();
			currentNode.position.y = y;
			
	
