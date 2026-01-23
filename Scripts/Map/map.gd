extends Node2D

var mapLength: int = 10
var mapMaxHeight: int = 7

var mapNodes: Array[Array] = []

func _ready() -> void:
	buildNodes()

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
	for i in range(mapLength - 1):
		var rowACount = mapNodes[i].size()
		var rowBCount = mapNodes[i + 1].size()
		
		var index = 0
