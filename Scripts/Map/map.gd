extends Node2D

var mapLength: int = 10
var mapMaxHeight: int = 7

var mapNodes: Array[Array] = []

func _ready() -> void:
	buildNodes()
	

func buildNodes() -> void:
	for i in range(mapLength):
		var maxSliceHeight = mapMaxHeight
		var minSliceHeight = 2
		if i == 0 or i == mapLength - 1:
			maxSliceHeight = 1
			minSliceHeight = 1
		elif i == 1 or i == mapLength - 2:
			maxSliceHeight = 3
		
		var sliceHeight = randi_range(minSliceHeight, maxSliceHeight)
		
		print(sliceHeight)
		mapNodes.append([])
		for j in range(sliceHeight):
			var nodePos: Vector2 = Vector2()
			nodePos.x = 100 + i * 100
			nodePos.y = 324 - (int)(80 * (sliceHeight - 1) / 2) + 80 * j
			mapNodes[i].append(MapNode.new(nodePos, MapNode.MapNodeType.Enemy))
			add_child(mapNodes[i][j])

func connectNodes() -> void:
	for i in range(mapLength - 1):
		var rowACount = mapNodes[i].size()
		var rowBCount = mapNodes[i + 1].size()
		
		var index = 0
