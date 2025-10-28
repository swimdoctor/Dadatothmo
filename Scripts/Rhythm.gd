class_name Rhythm
extends Node2D

@export var moveInventory: Array[Move] = []

@export var bpm:float = 120.0
@export var successThreshold = 0.2
@onready var timePerBeat = 60/bpm
var timeTillBeat = 0
var beat = 0;

var timeSinceLastNote = 0
var noteQueue = []

var interFrameInput
# this stores a number of seconds
var interFrameTimestamp

var click = preload("res://Sounds/metronomeClick.mp3")

signal beatHit(size:float)
signal inputPressed(direction:String, time:float)
signal movePerformed(name:String)

func _ready() -> void:
	Engine.max_fps = 60
	print("Move Inventory: ");
	for move in moveInventory:
		print(move.getString())
	
	Input.set_use_accumulated_input(false)
	

func _process(delta):
	
	# if it has been a while since last keypress clear the cache
	timeSinceLastNote += delta
	if timeSinceLastNote > (timePerBeat + successThreshold * 2):
		noteQueue.clear()
	
	# handle beat hits
	timeTillBeat -= delta
	if timeTillBeat <= 0:
		while timeTillBeat <= 0:
			timeTillBeat += timePerBeat
		beat += 1
		if beat % 4 == 0:
			emit_signal("beatHit", 1.2)
			$ClickPlayer.pitch_scale = .8
		else:
			emit_signal("beatHit", 1.1)
			$ClickPlayer.pitch_scale = 1
		$ClickPlayer.play()
	
	
	# if there was no input since last frame, return early
	if interFrameInput == null:
		return
	
	# plug this baby into desmos
	# 0 when the input is on the beat
	# domain is (-timePerBeat/2, timePerBeat/2)
	# negative when before the beat, positive after
	var timeFromNearestBeat = fmod(interFrameTimestamp - timePerBeat/2, timePerBeat) - timePerBeat/2
	
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
		print(event.keycode);
		interFrameTimestamp = Time.get_ticks_usec() / 1_000_000.0
		interFrameInput = event.keycode



func playNote(direction, timeFromNearestBeat):
	emit_signal("inputPressed", direction, timeFromNearestBeat)
	
	# print("x")
	# println("y")
	
	# print("x".."y")
	
	# print("x" + "y")
	
	# print(f"{x}{y}")
	
	
	print("You pressed ", Move.getNoteString(direction), " ", abs(timeFromNearestBeat), " seconds ", 
		"early" if (timeFromNearestBeat > 0) else "late")
	
	# return on invalid input times
	if abs(timeFromNearestBeat) > successThreshold:
		noteQueue.clear()
		return
	
	timeSinceLastNote = 0
	noteQueue.append(direction)
	
	#if noteQueue.size() > 4:
		#noteQueue.pop_front()
	
	for move in moveInventory:
		var validMove = true
		if noteQueue.size() >= move.notes.size():
			for i in range(move.notes.size()):
				if noteQueue[i] != move.notes[i]:
					validMove = false
			
			if validMove:
				movePerformed.emit(move.name)
				print("YOU DID ", move.name)
			
	
	print(noteQueue)
