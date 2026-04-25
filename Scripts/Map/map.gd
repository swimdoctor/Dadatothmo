class_name GameMap
extends Node2D

# ── Grid / world dimensions ───────────────────────────────────────────────────
const CHUNK_HEIGHT: int = 13
var chunk_width: int = 23          # X tiles; adjust freely

# ── Poisson disc parameters ───────────────────────────────────────────────────
var min_dist: float = 3.0
var sample_attempts: int = 100
var max_dist_mult: float = 3.0

# ── Connection parameters ─────────────────────────────────────────────────────
var max_path_length: float = 8.0
var purge_percent: float = 0.15

# ── Tile rendering ───────────────────────────────────────────────────────────
const TILE_SIZE: int = 16                      # sprite native size in px
const DRAW_SCALE: float = 48.0                 # rendered size in px (3x)
const TILE_SCALE: float = DRAW_SCALE / TILE_SIZE  # sprite scale factor (3.0)

# ── Debug drawing ─────────────────────────────────────────────────────────────
var draw_scale: float = DRAW_SCALE
var draw_offset: Vector2 = Vector2(24, 12)

# ── Tile grid (phase 2+) ──────────────────────────────────────────────────────
# Sparse dict: Vector2i(tile_x, tile_y) -> Sprite2D
# Populated in _place_node_tiles(); used by phase 3 path routing.
var _tile_sprites: Dictionary = {}
# Parallel dict: Vector2i -> int tile ID, for routing logic to read
var _tile_ids: Dictionary = {}
# Snapped 2x2 tile origins per point index (Vector2i, top-left of 2x2 block)
var _node_tile_origins: Array = []

# ── Internal state ────────────────────────────────────────────────────────────
var _grid: Array = []              # [x][y] -> Vector2 point or null
var _grid_cell_size: float
var _active_list: Array = []       # Vector2 candidates for Poisson
var _points: Array = []            # Vector2 accepted points
var _connections: Array = []       # Array of [i, j] index pairs
var _map_nodes: Array = []         # MapNode objects, parallel to _points


func _ready() -> void:
	var map = gamemanager.load_map()


# ═════════════════════════════════════════════════════════════════════════════
#  PUBLIC ENTRY POINTS  (called by gamemanager, not _ready)
# ═════════════════════════════════════════════════════════════════════════════

func create_map() -> void:
	seed(68)
	_grid_cell_size = min_dist / sqrt(2.0)
	_init_grid()
	_generate_points()
	_connect_points()
	_delete_intersecting_connections()
	_enforce_connectivity()
	_build_map_nodes()
	_place_node_tiles()
	queue_redraw()


## Called by gamemanager after the map is made visible and added to the scene.
## Puts the player on the entry node (index 0) to begin traversal.
func start_map() -> void:
	if _map_nodes.size() == 0:
		return
	_map_nodes[0].playerMovesOn()
	_map_nodes[0].sprite.texture = preload("res://Images/Test/Map/NPC.png");


# ═════════════════════════════════════════════════════════════════════════════
#  PHASE 1-A: POISSON DISC POINT GENERATION
# ═════════════════════════════════════════════════════════════════════════════

func _init_grid() -> void:
	_grid.clear()
	var grid_w: int = int(ceil(chunk_width / _grid_cell_size))
	var grid_h: int = int(ceil(CHUNK_HEIGHT / _grid_cell_size))
	for x in range(grid_w):
		_grid.append([])
		for _y in range(grid_h):
			_grid[x].append(null)


func _generate_points() -> void:
	_points.clear()
	_active_list.clear()

	# Fixed entry (left) and exit (right) seed points
	var entry := Vector2(1, 4 + roundi(randf() * 3))
	var exit_p := Vector2(chunk_width - 2, 4 + roundi(randf() * 3))
	_add_point(entry)
	_add_point(exit_p)

	while _active_list.size() > 0:
		var idx: int = randi() % _active_list.size()
		var p: Vector2 = _active_list[idx]
		var found := false

		for _i in range(sample_attempts):
			var candidate := _random_point_around(p)
			if _is_valid_point(candidate):
				_add_point(candidate)
				found = true
				break

		if not found:
			_active_list.remove_at(idx)

	_purge_points()


func _add_point(p: Vector2) -> void:
	_points.append(p)
	_active_list.append(p)
	var gp := _to_grid_pos(p)
	_grid[int(gp.x)][int(gp.y)] = p


func _to_grid_pos(p: Vector2) -> Vector2:
	return Vector2(int(p.x / _grid_cell_size), int(p.y / _grid_cell_size))


func _random_point_around(p: Vector2) -> Vector2:
	var r: float = randf_range(min_dist, min_dist * max_dist_mult)
	var angle: float = randf_range(0.0, TAU)
	var candidate := Vector2(
		roundi(p.x + cos(angle) * r),
		roundi(p.y + sin(angle) * r)
	)
	candidate.y = clampi(int(candidate.y), 1, CHUNK_HEIGHT - 2)
	return candidate


func _is_valid_point(p: Vector2) -> bool:
	# Bounds check
	if p.x < 0 or p.x >= chunk_width or p.y < 0 or p.y >= CHUNK_HEIGHT:
		return false

	# Diamond clip — keeps points away from the four corners
	var cutoff: float = (CHUNK_HEIGHT / 2.0) + 1.0
	if p.x + p.y < cutoff: return false
	if (chunk_width - p.x) + p.y < cutoff: return false
	if CHUNK_HEIGHT + p.x - p.y < cutoff: return false
	if CHUNK_HEIGHT + (chunk_width - p.x) - p.y < cutoff: return false

	# Poisson minimum distance check against grid neighbours
	var gp := _to_grid_pos(p)
	for dx in range(-2, 3):
		for dy in range(-2, 3):
			var nx: int = int(gp.x) + dx
			var ny: int = int(gp.y) + dy
			if nx < 0 or nx >= _grid.size(): continue
			if ny < 0 or ny >= _grid[nx].size(): continue
			var neighbour = _grid[nx][ny]
			if neighbour != null:
				if neighbour.distance_to(p) < min_dist:
					return false
	return true


func _purge_points() -> void:
	# Never purge the two seed points (index 0 and 1)
	var i := 2
	while i < _points.size():
		if randf() < purge_percent:
			var gp := _to_grid_pos(_points[i])
			_grid[int(gp.x)][int(gp.y)] = null
			_points.remove_at(i)
		else:
			i += 1


# ═════════════════════════════════════════════════════════════════════════════
#  PHASE 1-B: GRAPH CONNECTION
# ═════════════════════════════════════════════════════════════════════════════

func _connect_points() -> void:
	_connections.clear()
	for i in range(_points.size()):
		for j in range(i + 1, _points.size()):
			var pi: Vector2 = _points[i]
			var pj: Vector2 = _points[j]

			# Left-to-right only (no vertical connections)
			if pi.x == pj.x:
				continue

			var dx: float = pi.x - pj.x
			var dy: float = pi.y - pj.y
			var length: float = sqrt(dx * dx + dy * dy)

			if length > max_path_length:
				continue

			# Make sure i is always the left node
			var left_i := i if _points[i].x < _points[j].x else j
			var right_i := j if _points[i].x < _points[j].x else i

			# Check max outputs (3) on the left node
			var left_outputs := _count_outputs(left_i)
			if left_outputs >= 3:
				continue

			# Near-collinear point blocking — reject if another point is too
			# close to the line segment between pi and pj
			if _segment_blocked(i, j, length):
				continue

			_connections.append([left_i, right_i])


func _count_outputs(node_idx: int) -> int:
	var count := 0
	for c in _connections:
		if c[0] == node_idx:
			count += 1
	return count


func _count_inputs(node_idx: int) -> int:
	var count := 0
	for c in _connections:
		if c[1] == node_idx:
			count += 1
	return count


func _segment_blocked(i: int, j: int, seg_len: float) -> bool:
	var x1: float = _points[i].x
	var y1: float = _points[i].y
	var x2: float = _points[j].x
	var y2: float = _points[j].y
	for k in range(_points.size()):
		if k == i or k == j:
			continue
		var cx: float = _points[k].x
		var cy: float = _points[k].y
		var dot: float = ((cx - x1) * (x2 - x1) + (cy - y1) * (y2 - y1)) / (seg_len * seg_len)
		if dot < 0.0 or dot > 1.0:
			continue
		var closest_x: float = x1 + dot * (x2 - x1)
		var closest_y: float = y1 + dot * (y2 - y1)
		var dist: float = sqrt(pow(closest_x - cx, 2) + pow(closest_y - cy, 2))
		if dist < 1.0:
			return true
	return false


func _delete_intersecting_connections() -> void:
	var i := 0
	while i < _connections.size():
		var j := i + 1
		while j < _connections.size():
			var p1: Vector2 = _points[_connections[i][0]]
			var p2: Vector2 = _points[_connections[i][1]]
			var p3: Vector2 = _points[_connections[j][0]]
			var p4: Vector2 = _points[_connections[j][1]]

			var denom: float = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y)
			if abs(denom) < 0.0001:
				j += 1
				continue

			var uA: float = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)) / denom
			var uB: float = ((p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)) / denom

			if uA > 0.0 and uA < 1.0 and uB > 0.0 and uB < 1.0:
				# Intersection — remove the longer connection
				var len_i: float = _points[_connections[i][0]].distance_to(_points[_connections[i][1]])
				var len_j: float = _points[_connections[j][0]].distance_to(_points[_connections[j][1]])
				if len_i >= len_j:
					_connections.remove_at(i)
					j = i  # restart inner loop from new i
				else:
					_connections.remove_at(j)
				# don't increment j — it now points to the next element
			else:
				j += 1
		i += 1


# ═════════════════════════════════════════════════════════════════════════════
#  PHASE 1-C: CONNECTIVITY ENFORCEMENT
#  Every node must have at least one input AND one output (except the fixed
#  entry [index 0] which needs only outputs, and exit [index 1] which needs
#  only inputs). Removes orphan nodes that can't be fixed.
# ═════════════════════════════════════════════════════════════════════════════

func _enforce_connectivity() -> void:
	var changed := true
	while changed:
		changed = false
		var i := 2  # never remove seed nodes 0 (entry) or 1 (exit)
		while i < _points.size():
			var inputs := _count_inputs(i)
			var outputs := _count_outputs(i)
			if inputs == 0 or outputs == 0:
				# Remove this point and all its connections
				var gp := _to_grid_pos(_points[i])
				_grid[int(gp.x)][int(gp.y)] = null
				_points.remove_at(i)
				# Rebuild connections without this index, shifting indices down
				var new_connections: Array = []
				for c in _connections:
					if c[0] == i or c[1] == i:
						continue
					var a: int = c[0] if c[0] < i else c[0] - 1
					var b: int = c[1] if c[1] < i else c[1] - 1
					new_connections.append([a, b])
				_connections = new_connections
				changed = true
			else:
				i += 1


# ═════════════════════════════════════════════════════════════════════════════
#  PHASE 1-D: BUILD MAP NODES
# ═════════════════════════════════════════════════════════════════════════════

func _node_type() -> MapNode.MapNodeType:
	var r := randf()
	if r < 0.8:
		return MapNode.MapNodeType.Enemy
	if r < 1.0:
		return MapNode.MapNodeType.Loot
	return MapNode.MapNodeType.NPC


func _build_map_nodes() -> void:
	# Clear any previously built nodes
	for n in _map_nodes:
		n.queue_free()
	_map_nodes.clear()

	# Create one MapNode per point
	for i in range(_points.size()):
		# Position MapNode at the center of its snapped 2x2 tile block.
		# _node_tile_origins isn't populated yet at this point, so we compute
		# it inline here; _place_node_tiles() will populate the array afterward.
		var snapped := _snap_to_node_origin(_points[i])
		var world_pos := draw_offset + (Vector2(snapped) + Vector2(1.0, 1.0)) * DRAW_SCALE
		var node_type := _node_type()
		# Index 0 = entry, index 1 = exit — could assign special types later
		var map_node := MapNode.create(world_pos, Vector2(40, 40), node_type)
		_map_nodes.append(map_node)
		add_child(map_node)

	# Wire up connections using MapNode's existing appendNode logic
	for c in _connections:
		_map_nodes[c[0]].appendNode(_map_nodes[c[1]])

	# Give every node a reference back to this map for redraw callbacks
	for n in _map_nodes:
		n.map = self



# ═════════════════════════════════════════════════════════════════════════════
#  PHASE 2: NODE TILE PLACEMENT
#  Snaps each node to an even 2x2 tile boundary and writes four tile-6
#  quarter-circle sprites into the scene. Connection-aware tile variants
#  (7, 8, 9) will be assigned in a later pass once path routing is complete.
# ═════════════════════════════════════════════════════════════════════════════

func _place_node_tiles() -> void:
	# Clear any previously placed tile sprites
	for sprite in _tile_sprites.values():
		sprite.queue_free()
	_tile_sprites.clear()
	_tile_ids.clear()
	_node_tile_origins.clear()
	
	for i in range(_points.size()):
		var snapped := _snap_to_node_origin(_points[i])
		_node_tile_origins.append(snapped)
		#_write_node_block(snapped)


## Snaps a float point position to the nearest even tile coordinate so the
## 2x2 block always aligns to tile boundaries.
func _snap_to_node_origin(p: Vector2) -> Vector2i:
	var tx: int = int(round(p.x))
	var ty: int = int(round(p.y))
	# Clamp so the 2x2 block (origin + 1) stays within bounds
	tx = clampi(tx, 0, chunk_width - 2)
	ty = clampi(ty, 0, CHUNK_HEIGHT - 2)
	return Vector2i(tx, ty)


## Writes a 2x2 block of tile-6 sprites at the given top-left tile origin.
## Quadrant layout (all tile 6 for now — variants added in a later phase):
##   [0] top-left     [1] top-right
##   [2] bottom-left  [3] bottom-right
## Each quarter is a rotated/flipped copy of the base tile-6 sprite so the
## circle center of every quarter lands at the shared corner of the 2x2.
func _write_node_block(origin: Vector2i) -> void:
	# Rotation and flip for each of the 4 quadrant positions.
	# The base tile has its circle center at the bottom-right corner, so:
	#   top-left     -> rotate 180°
	#   top-right    -> flip horizontal (mirror)
	#   bottom-left  -> flip vertical
	#   bottom-right -> no transform
	const TRANSFORMS: Array = [
		{"rot": 0.0, "flip_h": false, "flip_v": false},  # top-left
		{"rot": 0.0, "flip_h": true,  "flip_v": false},  # top-right
		{"rot": 0.0, "flip_h": false, "flip_v": true},   # bottom-left
		{"rot": 0.0, "flip_h": true,  "flip_v": true},   # bottom-right
	]

	var offsets: Array = [
		Vector2i(0, 0), Vector2i(1, 0),
		Vector2i(0, 1), Vector2i(1, 1),
	]

	for q in range(4):
		var tile_pos : Vector2i = origin + offsets[q]
		var sprite := _make_tile_sprite(6, TRANSFORMS[q], tile_pos)
		add_child(sprite)
		_tile_sprites[tile_pos] = sprite
		_tile_ids[tile_pos] = 6


## Creates a positioned and transformed Sprite2D for a given tile ID.
func _make_tile_sprite(tile_id: int, transform: Dictionary, tile_pos: Vector2i) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = load("res://Images/Test/Map/Tiles/Tile_%d_0.png" % tile_id)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(TILE_SCALE, TILE_SCALE)
	sprite.flip_h = transform["flip_h"]
	sprite.flip_v = transform["flip_v"]
	sprite.rotation = transform["rot"]
	sprite.z_index = -1
	# Sprite2D position is its center; offset by half a tile so tile_pos is top-left
	sprite.position = draw_offset + Vector2(tile_pos) * DRAW_SCALE + Vector2(DRAW_SCALE * 0.5, DRAW_SCALE * 0.5)
	return sprite

# ═════════════════════════════════════════════════════════════════════════════
#  DEBUG DRAWING
# ═════════════════════════════════════════════════════════════════════════════

func _draw() -> void:
	# Draw grid boundary
	var grid_rect := Rect2(
		draw_offset,
		Vector2(chunk_width, CHUNK_HEIGHT) * draw_scale
	)
	#draw_rect(grid_rect, Color(0.15, 0.15, 0.15), false, 1.0)

	# Draw connections — highlight if the source node is occupied
	for c in _connections:
		var src: MapNode = _map_nodes[c[0]]
		var a := draw_offset + (Vector2(_node_tile_origins[c[0]]) + Vector2(1.0, 1.0)) * DRAW_SCALE
		var b := draw_offset + (Vector2(_node_tile_origins[c[1]]) + Vector2(1.0, 1.0)) * DRAW_SCALE
		var col := Color.GOLDENROD if src.occupied else Color.TRANSPARENT
		draw_line(a, b, col, 8.0)

	# Draw points — colour by traversal state, centered on the 2x2 tile block
	for i in range(_points.size()):
		var origin : Vector2= _node_tile_origins[i]
		var pos := draw_offset + (Vector2(origin) + Vector2(1.0, 1.0)) * DRAW_SCALE
		var node: MapNode = _map_nodes[i]
		var col: Color
		if node.occupied:
			col = Color.DARK_RED
		elif node.highlighted:
			col = Color.YELLOW
		elif i == 0:
			col = Color.GREEN
		elif i == 1:
			col = Color.RED
		else:
			col = Color.WHITE
		draw_circle(pos, 6.0, col)


## MapNode calls this after any state change so map.gd redraws connections.
func on_node_state_changed() -> void:
	queue_redraw()


func _tile_to_world(tile_pos: Vector2) -> Vector2:
	return draw_offset + tile_pos * draw_scale
