class_name RhythmVisuals
extends Control

@onready var rhythm: = $"../.."

func _ready() -> void:
	#print(rhythm.bpm)
	
	rhythm.inputPressed.connect(playNote)
	rhythm.movePerformed.connect(moveCompleted)
	rhythm.beatHit.connect(beatHit)
	
	$MovesText.text = "Moves:\n"
	for move in rhythm.moveInventory:
		$MovesText.text += move.getString() + "\n"
		
	var movesText:String = $MovesText.text
	
	movesText = movesText.replace("UP   ", str("[img=24x24]" + "Images/Test/Arrow0.png" + "[/img] "))
	movesText = movesText.replace("DOWN ", str("[img=24x24]" + "Images/Test/Arrow1.png" + "[/img] "))
	movesText = movesText.replace("LEFT ", str("[img=24x24]" + "Images/Test/Arrow3.png" + "[/img] "))
	movesText = movesText.replace("RIGHT", str("[img=24x24]" + "Images/Test/Arrow2.png" + "[/img] "))
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
	
	image = load("res://Images/Test/Arrow" + str(direction) + ".png")

	# $NotePlayedText.add_image(image, 256, 256, Color(1, 1, 1, 1), 0, Rect2(), "note")

	$NotePlayedText.text += ("[img=32x32]" + "Images/Test/Arrow" + str(direction) + ".png" + "[/img] ")
	# print("You pressed ", Move.getNoteString(direction), " ", abs(timeFromBeat), " seconds ","early" if (timeFromBeat > 0) else "late")

func moveCompleted(moveName:String):
	$NotePlayedText.text = ""
	$NotePlayedText.text = "Performed " + moveName + "!"

func beatHit(size:float):
	$BeatIndicator.scale = Vector2(size,size)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	
	tween.tween_property($BeatIndicator, "scale", Vector2(1,1), 0.1)
