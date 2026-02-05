class_name RhythmVisuals
extends Control

@onready var rhythm: = $"../.."

@export var spawn_y: float = 250.0
@export var marker_size: float = 100.0

# The 'width' of the bottom bar, in beats.
const BAR_WIDTH_BEATS = 12;

var arrowRows: Array[HBoxContainer] = []

@onready var arrow_ui = preload("res://Scenes/arrowUI/arrow_ui.tscn");

func _ready() -> void:
	rhythm.playedNote.connect(playedNote)
	rhythm.clearedNotes.connect(clearedNotes)
	rhythm.moveCompleted.connect(moveCompleted)
	rhythm.beatHit.connect(beatHit)
	
	# begin polyphonic audio streams
	$NotePlayer.play()

func display_moves():
	for move in rhythm.moveInventory:
		var moveRow = HBoxContainer.new()
		moveRow.add_child(texnode(move.icon))
		moveRow.custom_minimum_size.y = 50
		
		var arrows = arrow_ui.instantiate();
		arrows.set_pattern(move.notes);
		moveRow.add_child(arrows);
		arrowRows.append(arrows);
		
		$MovesBox.add_child(moveRow)

func texnode(tex: Texture):
	var arrow = TextureRect.new()
	arrow.texture = tex
	arrow.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	arrow.expand_mode = TextureRect.ExpandMode.EXPAND_FIT_WIDTH
	return arrow

func _process(delta):
	$BeatText.text = str(rhythm.beat)
	
	$PlayerHealthBar.value = lerp($PlayerHealthBar.value, float(gamemanager.player_health), 0.1);
	$PlayerHealthBar.max_value = gamemanager.max_player_health;

func playedNote(direction: Move.Direction):
	# update arrow ui
	for i in arrowRows.size():
		arrowRows[i].set_completed_moves(rhythm.move_progress[i]);
	
	$NotePlayer.get_stream_playback().play_stream(getNoteSound(direction)) 
	$BoomPlayer.play()

func clearedNotes():
	# reset arrow ui
	for row in arrowRows:
		row.reset();
		
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	
	$FailurePlayer.play()

func moveCompleted(move: Move):
	$NotePlayedText.text = ""
	$NotePlayedText.text = "Performed " + move.name + "!"
	
	$SuccessPlayer.play()
	
	# actual logic for each attack
	spawn_move(move)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel()
		
	$BuildupPlayer.stop()

func beatHit(downbeat: bool):
	$BeatIndicator.scale = Vector2.ONE * (1.5 if downbeat else 1.3)*4
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($BeatIndicator, "scale", Vector2(1,1)*4, 0.1)
	
	spawn_marker(downbeat, get_viewport_rect().size.x)
	
	$ClickPlayer.pitch_scale = 1.4 if downbeat else 1
	$ClickPlayer.play()

func screen_end():
	return get_viewport_rect().size.x

func move_across_screen(node: Node):
	# Move node across the screen and remove it after travel
	var end_x = node.position.x - screen_end() - marker_size
	var travel_time = BAR_WIDTH_BEATS * rhythm.beat_time()
	var tween = create_tween()
	tween.tween_property(node, "position:x", end_x, travel_time)
	tween.tween_callback(Callable(node, "queue_free"))
	
func spawn_marker(downbeat: bool, start_x: float):
	var marker = ColorRect.new()
	marker.color = Color.BLACK if downbeat else Color.GRAY
	marker.size = Vector2(10, marker_size)
	marker.position = Vector2(start_x, spawn_y)
	 
	add_child(marker)
	move_across_screen(marker)
	
func spawn_move(move: Move):
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = move.icon
	sprite.position = Vector2(screen_end(), spawn_y)
	
	add_child(sprite)
	move_across_screen(sprite)
	
func getNoteSprite(direction: Move.Direction):
	match direction:
		Move.Direction.UP:    return preload("res://Images/Test/Arrow_Up.png")
		Move.Direction.DOWN:  return preload("res://Images/Test/Arrow_Down.png")
		Move.Direction.LEFT:  return preload("res://Images/Test/Arrow_Left.png")
		Move.Direction.RIGHT: return preload("res://Images/Test/Arrow_Right.png")

func getNoteSound(direction: Move.Direction):
	match direction:
		Move.Direction.UP:    return preload("res://Sounds/hitup.mp3")
		Move.Direction.DOWN:  return preload("res://Sounds/hitdown.mp3")
		Move.Direction.LEFT:  return preload("res://Sounds/hitleft.mp3")
		Move.Direction.RIGHT: return preload("res://Sounds/hitright.mp3")
