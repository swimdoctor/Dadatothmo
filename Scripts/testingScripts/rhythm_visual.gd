class_name RhythmVisuals
extends Control

@onready var rhythm: = $"../.."

var beat_index: int = 1
@export var spawn_y: float = 250.0
@export var marker_size: float = 100.0

func _ready() -> void:
	#print(rhythm.bpm)
	
	rhythm.inputPressed.connect(playNote)
	rhythm.movePerformed.connect(moveCompleted)
	rhythm.beatHit.connect(beatHit)
	
	$MovesText.text = "Moves:\n"
	for move in rhythm.moveInventory:
		$MovesText.text += move.getString() + "\n"
		
	var movesText:String = $MovesText.text
	
	movesText = movesText.replace("UP   ", str("[img=24x24]" + "Images/Test/Arrow_Up.png" + "[/img] "))
	movesText = movesText.replace("DOWN ", str("[img=24x24]" + "Images/Test/Arrow_Down.png" + "[/img] "))
	movesText = movesText.replace("LEFT ", str("[img=24x24]" + "Images/Test/Arrow_Left.png" + "[/img] "))
	movesText = movesText.replace("RIGHT", str("[img=24x24]" + "Images/Test/Arrow_Right.png" + "[/img] "))
	# print(movesText)
	
	$MovesText.text = movesText;
	
		#print(move.getString())
	
func _process(delta):
	$BeatText.text = str(rhythm.beat)
	
	if rhythm.noteQueue.size() == 0:
		$NotePlayedText.text = ""
		
func playNote(direction, timeFromBeat):
	print(direction)
	
	#var imgName:String
	var image:Texture2D
	
	#image = load("res://Images/Test/Arrow" + str(direction) + ".png")

	# $NotePlayedText.add_image(image, 256, 256, Color(1, 1, 1, 1), 0, Rect2(), "note")

	$NotePlayedText.text += ("[img=32x32]" + Move.getNoteSpriteName(direction) + "[/img] ")
	# print("You pressed ", Move.getNoteString(direction), " ", abs(timeFromBeat), " seconds ","early" if (timeFromBeat > 0) else "late")

func moveCompleted(move: Move):
	$NotePlayedText.text = ""
	$NotePlayedText.text = "Performed " + move.name + "!"
	
	# actual logic for each attack
	spawn_move(move)

func beatHit(size:float):
	$BeatIndicator.scale = Vector2(size,size)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property($BeatIndicator, "scale", Vector2(1,1), 0.1)
	
	# spawn the measure markers
	beat_index += 1
	if beat_index > 4:
		beat_index = 1
	
	var is_measure_start = (beat_index == 1)
	spawn_marker(is_measure_start)
	
func get_travel_time() -> float:
	var beats_per_measure = 4
	var measures_to_cross = 3
	var beats_to_cross = measures_to_cross * beats_per_measure
	var seconds_per_beat = 60.0 / rhythm.bpm
	var travel_time = beats_to_cross * seconds_per_beat
	
	return travel_time
	
func spawn_marker(is_measure_start: bool):
	var marker = ColorRect.new()
	marker.color = Color.BLACK if is_measure_start else Color.GRAY
	marker.size = Vector2(10, marker_size)
	
	var start_x = 0 - marker.size.x
	var end_x = get_viewport_rect().size.x + marker.size.x
	marker.position = Vector2(start_x, spawn_y)
	 
	add_child(marker)
	
	# Move marker across the screen and remove it after travel
	var tween = create_tween()
	
	var travel_time = get_travel_time()
	
	tween.tween_property(marker, "position:x", end_x, travel_time)
	tween.tween_callback(Callable(marker, "queue_free"))
	
func spawn_move(move: Move):
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = move.icon
	
	add_child(sprite)
	
	# Start position (offscreen left)
	var start_x = 0 - sprite.texture.get_width()
	var end_x = get_viewport_rect().size.x + sprite.texture.get_width()
	sprite.position = Vector2(start_x, spawn_y)
	
	var travel_time = get_travel_time()
	
	# Animate across the screen
	var tween = create_tween()
	tween.tween_property(sprite, "position:x", end_x, travel_time)
	tween.tween_callback(Callable(sprite, "queue_free"))
