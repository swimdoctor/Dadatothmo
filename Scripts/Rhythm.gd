class_name Rhythm
extends Node2D

@export var moveInventory: Array[Move] = []

@export var beats_per_minute: float = 120.0
func beat_time():
	return 60 / beats_per_minute

@export var successThreshold = 1.0
var timeTillBeat = 0
var timeOfLastBeat = null
var timeOfNextBeat = null
var beat = -1; # start at negative one so first beat is 0

@export var timingOffset: float = 0.04

var timeSinceLastNote = 0
#tracking move completion directly instead of relying on a queue of inputs
var move_progress: Array[int] = [];

var interFrameInput
# this stores a number of seconds
var interFrameTimestamp

signal beatHit(downbeat: bool)
signal playedNote(direction: Move.Direction)
signal clearedNotes()
signal moveCompleted(name:String)

@onready var rhythm_visual = $"Camera2D/Control"

#Cedric did this. This is here just because of how player damage is currently implemented
#Can move to a different script later
#Player base stats
var hp = 100
var defense = 10
@export var speed = 50

#Elemental multipliers (%)
var void_percent = 100
var ice_percent = 100
var nature_percent = 100
var flame_lighting_percent = 100

var collisionBox
var moveSprite


func _ready() -> void:
	Engine.max_fps = 60
	print("Move Inventory: ");
	for move in gamemanager.move_list:
		moveInventory.append(move)
	
	for move in moveInventory:
		#Perform the "Rest" move when you start a fight
		if(move.name == "Rest"):
			move.recover(move.heal)
			print("You healed ", move.heal)
			$Camera2D/Control/NotePlayedText.text = "You start the fight by healing" 
		print(move.getString())
	
	move_progress.resize(moveInventory.size());
	move_progress.fill(0);
	
	Input.set_use_accumulated_input(false)
	
	(rhythm_visual as RhythmVisuals).display_moves()
	
	collisionBox = false
	moveSprite = %MoveSprite


func _process(delta):
	# if it has been a while since last keypress clear the cache
	timeSinceLastNote += delta
	if move_progress.any(func(num): return num > 0) && timeSinceLastNote > (beat_time() + successThreshold * 2):
		move_progress.fill(0);
		emit_signal("clearedNotes")
	
	# handle beat hits
	timeTillBeat -= delta
		
	if timeTillBeat <= 0:
		while timeTillBeat <= 0:
			timeTillBeat += beat_time()
		beat += 1
		emit_signal("beatHit", beat % 4 == 0)
		
		var now = Time.get_ticks_usec() / 1_000_000.0
		var overshoot = beat_time() - timeTillBeat
		timeOfLastBeat = (now - overshoot) + timingOffset
		timeOfNextBeat = timeOfLastBeat + beat_time()
		
	# if there was no input since last frame, return early
	if interFrameInput == null:
		return
	
	var timeFromLastBeat = abs(interFrameTimestamp - timeOfLastBeat)
	var timeToNextBeat   = abs(interFrameTimestamp - timeOfNextBeat)
	var timeDiff = min(timeFromLastBeat, timeToNextBeat)
	var earlyOrLate = "late" if timeFromLastBeat < timeToNextBeat else "early"
	
	if interFrameInput == "Up" || interFrameInput.contains("D-pad Up"):
		playNote(Move.Direction.UP, timeDiff, earlyOrLate)
	elif interFrameInput == "Right" || interFrameInput.contains("D-pad Right"):
		playNote(Move.Direction.RIGHT, timeDiff, earlyOrLate)
	elif interFrameInput == "Down" || interFrameInput.contains("D-pad Down"):
		playNote(Move.Direction.DOWN, timeDiff, earlyOrLate)
	elif interFrameInput == "Left" || interFrameInput.contains("D-pad Left"):
		playNote(Move.Direction.LEFT, timeDiff, earlyOrLate)
	
	interFrameInput = null
	interFrameTimestamp = null
	



func _input(event) -> void:
	if event.is_pressed():
		interFrameTimestamp = Time.get_ticks_usec() / 1_000_000.0
		print(event.as_text());
		interFrameInput = event.as_text()


func playNote(direction, timeFromNearestBeat, earlyOrLate):
	print("You pressed ", Move.getNoteString(direction), " ", abs(timeFromNearestBeat), " seconds ", earlyOrLate)
	
	timeSinceLastNote = 0
	
	# return on invalid input times
	
	if abs(timeFromNearestBeat) > successThreshold:
		move_progress.fill(0);
		emit_signal("clearedNotes")
		return
	#if(!collisionBox):
		#move_progress.fill(0);
		#emit_signal("clearedNotes")
		#return
	
	# update move progress
	
	for i in moveInventory.size():
		if(moveInventory[i].notes[move_progress[i]] == direction):
			move_progress[i] += 1;
			# check to see if move should be completed
			if(move_progress[i] == moveInventory[i].notes.size()):
				#do the move
				move_progress[i] = 0;
				moveInventory[i].do_move(gamemanager.current_enemies, self)
				moveCompleted.emit(moveInventory[i])
				moveSprite.texture = moveInventory[i].sprite
				moveSprite.self_modulate.a = 1.0;
				create_tween().tween_property(moveSprite, "self_modulate:a", 0, 1)

		else:
			move_progress[i] = 0;
	emit_signal("playedNote", direction)


func _on_box_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if(area.is_in_group("markers")):
		collisionBox = true
	pass # Replace with function body.


func _on_box_area_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if(area.is_in_group("markers")):
		collisionBox = false
	pass # Replace with function body.
