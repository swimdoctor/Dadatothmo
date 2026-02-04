class_name Rhythm
extends Node2D

@export var moveInventory: Array[Move] = []

@export var beats_per_minute: float = 120.0
func beat_time():
	return 60 / beats_per_minute

@export var successThreshold = 0.4
var timeTillBeat = 0
var beat = -1; # start at negative one so first beat is 0

var timeSinceLastNote = 0
var noteQueue: Array[Move.Direction] = []

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
var attack = 10
var defense = 10
@export var speed = 50

#Elemental multipliers (%)
var void_percent = 100
var ice_percent = 100
var nature_percent = 100
var flame_lighting_percent = 100


func _ready() -> void:
	Engine.max_fps = 60
	print("Move Inventory: ");
	for move in gamemanager.movelist:
		moveInventory.append(move)
	
	for move in moveInventory:
		print(move.getString())
	
	Input.set_use_accumulated_input(false)
	
	(rhythm_visual as RhythmVisuals).display_moves()


func _process(delta):
	# if it has been a while since last keypress clear the cache
	timeSinceLastNote += delta
	if !noteQueue.is_empty() && timeSinceLastNote > (beat_time() + successThreshold * 2):
		noteQueue.clear()
		emit_signal("clearedNotes")
	
	# handle beat hits
	timeTillBeat -= delta
	if timeTillBeat <= 0:
		while timeTillBeat <= 0:
			timeTillBeat += beat_time()
		beat += 1
		emit_signal("beatHit", beat % 4 == 0)
	
	# if there was no input since last frame, return early
	if interFrameInput == null:
		return
	
	# plug this baby into desmos
	# 0 when the input is on the beat
	# domain is (-timePerBeat/2, timePerBeat/2)
	# negative when before the beat, positive after
	var timeFromNearestBeat = fmod(interFrameTimestamp, beat_time()) - beat_time()/2
	print(timeFromNearestBeat)
	
	if interFrameInput == KEY_UP:
		playNote(Move.Direction.UP, timeFromNearestBeat)
	elif interFrameInput == KEY_RIGHT:
		playNote(Move.Direction.RIGHT, timeFromNearestBeat)
	elif interFrameInput == KEY_DOWN:
		playNote(Move.Direction.DOWN, timeFromNearestBeat)
	elif interFrameInput == KEY_LEFT:
		playNote(Move.Direction.LEFT, timeFromNearestBeat)
	
	interFrameInput = null
	interFrameTimestamp = null


func _input(event) -> void:
	if event is InputEventKey and event.is_pressed():
		interFrameTimestamp = Time.get_ticks_usec() / 1_000_000.0
		interFrameInput = event.keycode


func playNote(direction, timeFromNearestBeat):
	print("You pressed ", Move.getNoteString(direction), " ", abs(timeFromNearestBeat), " seconds ", 
		"early" if (timeFromNearestBeat > 0) else "late")
	
	timeSinceLastNote = 0
	
	# return on invalid input times
	if abs(timeFromNearestBeat) > successThreshold:
		noteQueue.clear()
		emit_signal("clearedNotes")
		return
	
	noteQueue.append(direction)
	emit_signal("playedNote", direction)
	
	#if noteQueue.size() > 4:
		#noteQueue.pop_front()
	
	# Check every move to see if one should be executed
	for move in moveInventory:
		# Ensure note queue is the right size
		if noteQueue.size() != move.notes.size():
			continue;
		
		# Check that the note queue matches
		var exactMatch = true
		for i in range(move.notes.size()):
			if noteQueue[i] != move.notes[i]:
				exactMatch = false
		if (!exactMatch):
			continue;
		
		# do the move
		noteQueue.clear()
		move.do_move(gamemanager.current_enemies, self)
		moveCompleted.emit(move)
