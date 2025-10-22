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
	
	# find the relative time from the nearest beat
	# min(timeTillBeat, timeSinceLastBeat)
	var timeFromNearestBeat = min(timeTillBeat, timePerBeat - timeTillBeat)
	timeFromNearestBeat *= sign(timePerBeat/2 - timeTillBeat)
	
	if Input.is_action_just_pressed("up"):
		playNote(Move.Note.UP, timeFromNearestBeat)
	if Input.is_action_just_pressed("right"):
		playNote(Move.Note.RIGHT, timeFromNearestBeat)
	if Input.is_action_just_pressed("down"):
		playNote(Move.Note.DOWN, timeFromNearestBeat)
	if Input.is_action_just_pressed("left"):
		playNote(Move.Note.LEFT, timeFromNearestBeat)

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed():
		print(event.keycode);
		
	var timestamp = Time.get_ticks_usec()
	
	#if event.keycode == KEY_UP:
		#playNote(Move.Note.UP, Time.get_ticks_usec())
	#if event.keycode == KEY_RIGHT:
		#playNote(Move.Note.RIGHT, timeFromNearestBeat)
	#if event.keycode == KEY_DOWN:
		#playNote(Move.Note.DOWN, timeFromNearestBeat)
	#if event.keycode == KEY_LEFT:
		#playNote(Move.Note.LEFT, timeFromNearestBeat)
	#playNote()

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
